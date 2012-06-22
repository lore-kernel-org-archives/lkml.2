Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510Ab2FVTxJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 15:53:09 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:43187 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756374Ab2FVTxH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 15:53:07 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxKDZaCq-GP2LJpLnDKc=Zd1pmnr8Rq7bBXH9eGuyiyew@mail.gmail.com>
References: <bug-41622-5873@https.bugzilla.kernel.org/> <20120622121523.4DF5911F873@bugzilla.kernel.org>
 <CA+55aFxKDZaCq-GP2LJpLnDKc=Zd1pmnr8Rq7bBXH9eGuyiyew@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 22 Jun 2012 13:52:45 -0600
Message-ID: <CAErSpo5T7kuAvh0YNNsOiCZ3s8sAmqGxpyq2BFmQPD1AVOcKSQ@mail.gmail.com>
Subject: Re: [Bug 41622] [REGRESSION][BISECTED] Notebook crashes upon
 detecting the PCI subsystem with kernels >= 2.6.24-rc7
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: bugzilla-daemon@bugzilla.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Maybe we should just try that patch in
>
>   https://bugzilla.kernel.org/show_bug.cgi?id=41622#c17
>
> but it really needs to happen early in a merge window. We didn't do
> that for 3.2, maybe we can do it for 3.6?

The first problem is still that this machine doesn't get anywhere at
all with ACPI enabled
(https://bugzilla.kernel.org/show_bug.cgi?id=41722), so we only get to
this transparent bridge issue with "acpi=off".

I really think that it would be better to solve the ACPI issue first
because it's too difficult to support an "acpi=off" config -- nobody
else tests that and very few users will be sophisticated enough to
even try it.  Unfortunately, I don't have any good ideas about the
ACPI issue other than the MTRR possibility Len suggested.

If we just fiddle with transparent bridge sizing, we're making the
problem go away, but we don't really know why, so I'm afraid of
breaking some other machine or tripping over this somewhere else.  My
guess is that we hang because we moved a device on top of something
else, and if we skip transparent bridge sizing, we avoid that device
move.  I do think it might be reasonable to avoid bridge sizing on the
grounds that we shouldn't move things unless we have to.  But right
now, we don't even know the real effect of skipping the bridge sizing.

Rogério, we might be able to at least identify a relevant difference
if you collect the dmesg from the "working" case ("acpi=off" with the
comment #17 patch), a video of the hanging case ("acpi=off" without
the patch, possibly with "boot_delay=1000" to slow things down) that
we can transcribe by hand, and the AIDA64 info from Windows that I
mentioned in bug 41722.
