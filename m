Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450Ab1BMIPt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 03:15:49 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37968 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab1BMIPr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 03:15:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mm5Ub7Ho6sJfwIayrFNFbiB4NvkUTJ4LTyJtG0ZQ6cBHCAMb948MevWQFaAV75ZTX3
         uCBDmDjUPZDUIU62dULZ+J5U/OpsU4XdsvFE2AAwLJ6K52b0tWUnjYpn+cEbtej7EGM8
         KorZyYYEPD8BShy5pJDLVx9NbfeVDIHMzz7A0=
MIME-Version: 1.0
In-Reply-To: <20110213062213.GA2525@darkstar.dhcp.inet.fi>
References: <20110213062213.GA2525@darkstar.dhcp.inet.fi>
Date: Sun, 13 Feb 2011 09:15:46 +0100
Message-ID: <AANLkTik8fv9SZ3_z0rVND_CrYBHmf67uvRQf2YanucjA@mail.gmail.com>
Subject: Re: Regression - Xorg start failed
From: Alex Riesen <raa.lkml@gmail.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, Chris Wright <chrisw@sous-sol.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 13, 2011 at 07:22, Dave Young <hidave.darkstar@gmail.com> wrote:
> Finally I bisected it, results:
> 47970b1b2aa64464bc0a9543e86361a622ae7c03 is first bad commit
> commit 47970b1b2aa64464bc0a9543e86361a622ae7c03
> Author: Chris Wright <chrisw@sous-sol.org>
> Date:   Thu Feb 10 15:58:56 2011 -0800
>
>    pci: use security_capable() when checking capablities during config space read
>
>    Eric Paris noted that commit de139a3 ("pci: check caps from sysfs file
>    open to read device dependent config space") caused the capability check
>    to bypass security modules and potentially auditing.  Rectify this by
>    calling security_capable() when checking the open file's capabilities
>    for config space reads.
>
>    Reported-by: Eric Paris <eparis@redhat.com>
>    Signed-off-by: Chris Wright <chrisw@sous-sol.org>
>    Signed-off-by: James Morris <jmorris@namei.org>
>

Actually, even reading the PCI capabilities fails with lspci
reporting "Capabilities: <access denied>" if run as root.
"libpciaccess" should have handled this situation, but still
it looks like a regression and it breaks existing systems.
