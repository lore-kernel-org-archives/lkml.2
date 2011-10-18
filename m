Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933254Ab1JRQQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 12:16:22 -0400
Received: from smtp-out.google.com ([74.125.121.67]:6281 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933019Ab1JRQQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 12:16:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:x-system-of-record;
	b=Rszrc2lUvAY0Eq2VPHyC9z70UxcSnobbinb1MNUucv7mSoyTz2C4KZssc6gOMPC9T
	9YIWFSwbwh4nkHG2EhsAg==
MIME-Version: 1.0
In-Reply-To: <j7k7sf$vbf$1@dough.gmane.org>
References: <j7k7sf$vbf$1@dough.gmane.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 18 Oct 2011 10:15:56 -0600
Message-ID: <CAErSpo7mhAsft5L4ifeWGhB+s2JQc8rbFEjJCfWEq7hW_8kR6A@mail.gmail.com>
Subject: Re: Possible bug in via-velocity on 3.0+
To: n00bsys0p <n00b@n00bsys0p.co.uk>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 10:01 AM, n00bsys0p <n00b@n00bsys0p.co.uk> wrote:
> Hi,
>
> I've been trying to get a custom 3.0 kernel to boot via PXE on a VIA EPIA
> EN15000G, and have run into a problem where once the thin client starts to
> load the kernel, the entire screen turns into a mosaic of random colours and
> characters.
>
> I've tested this serving a 2.6.35.8 kernel (configured identically to the
> 3.0) to the thin client where the master and client are both fitted with
> EPIA EN1500G, and it works perfectly. Also, I tried swapping the master's
> motherboard to a Gigabyte GA-D525TUD (Realtek LAN chip), and it succeeded in
> serving the 3.0 kernel to an EN15000G without a fault.
>
> In all test cases, the master was using a 3.0 kernel.
>
> Through this testing, I surmise that it is something to do with the LAN
> driver which is used, as this is the only thing I can see to have changed
> between the two running systems. Could it be accidentally overwriting the
> video RAM or something along those lines?
>
> Here's a link to a photo of what the screen looks like when it goes wrong:
> https://lh3.googleusercontent.com/-sXFP41oaF9U/TpyMFg89CqI/AAAAAAAAA-I/PBrltIm0cB4/s720/PXEFail.jpg

Let me see if I understand this correctly:

  - The problem is on the EN15000G client.
  - It occurs when the client boots 3.0 from a EN1500G server, but not
when booting the same 3.0 kernel image from a GA-D525TUD server.
  - It doesn't occur when booting 2.6.35.8 from a EN1500G server.
  - The client boots successfully and is usable, i.e., the only
problem is the temporary garbage on the screen during boot.

It would be useful to see the complete dmesg log from 2.6.35.8 on the
client.  If 3.0 actually does boot on the client, a dmesg log from 3.0
would also be useful.  There might be a clue if we can compare them.

Bjorn
