Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932680Ab1CXN0F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 09:26:05 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41223 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756909Ab1CXN0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 09:26:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Kr95WJYWbR8HdlX+mnllfmHEo2wl0McI7fTEI46Lzeoi7jKrcPCEM032whfCXr4BPe
         AudMNC1Tq2vU2JGuhdL8EXjGJ+YmglwZKX0/0OluqqSTuxmuqC7orbh0lzrv1jYsYrQu
         YOW7QdwtWgVmG/aJJUHQgpUtsZVzfLvQRhFn0=
MIME-Version: 1.0
In-Reply-To: <20110324131414.GA20612@thinkpad-t410>
References: <1300909189-4135-1-git-send-email-seth.forshee@canonical.com>
	<AANLkTinZpt8qmHzhe4WyteMt-C-nkVNwEGQVvq3Nk9Lx@mail.gmail.com>
	<20110324131414.GA20612@thinkpad-t410>
Date: Thu, 24 Mar 2011 13:26:00 +0000
Message-ID: <AANLkTinpKXM+gjJS9zVJNzkH+gTrzTNxz-C=CTXqKnN1@mail.gmail.com>
Subject: Re: [PATCH] eeepc-wmi: Add support for T101MT "Express Gate" key
From: Corentin Chary <corentin.chary@gmail.com>
To: Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <mjg@redhat.com>, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Seth Forshee <seth.forshee@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Also, it would be great to preserve key up and key down informations
>> (sparse keymap have an "autorelease" parameter to control that).
>
> Okay, I'll add some special casing for this key to support that.

You may have to add an optional callback for that in asus-wmi's driver
model because it's used by both asus-nb-wmi and eeepc-wmi, and we only
want this behavior for eeepc-wmi.

> Do you suggest ignoring the 0xea scan codes?

Yep, 0xea means "The key is still pressed", but it's useless if we
already repport key down and key up events correctly.
You'll have to ignore this scan code explicitly to remove traces in
dmesg (use KEY_IGNORE).

-- 
Corentin Chary
http://xf.iksaif.net
