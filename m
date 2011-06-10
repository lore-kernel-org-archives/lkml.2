Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265Ab1FJNx1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 09:53:27 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51444 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932184Ab1FJNxZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 09:53:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=st7H9NFpBnZ2Wp2my3opEt9DXV9sTk95qdiDsyGV2eM8vnvb/rKi745rSj7CZykgRt
         LO6qWKJo/JbkfcYul7FAD/EgADS+nxcqck0MRTkL32r65Gxt+qcgwplUfLD3irWlEGxt
         OCdU5ygnjPzELBX1hWpn7XVqV2Hyq682G70CY=
MIME-Version: 1.0
In-Reply-To: <20110610134821.GL24424@n2100.arm.linux.org.uk>
References: <BANLkTiknCeAxe30MJdVTxDom+ko8+EDQ4A@mail.gmail.com>
	<1307642718-22257-1-git-send-email-minipli@googlemail.com>
	<20110609155630.0f734351.akpm@linux-foundation.org>
	<1307711337-4042-1-git-send-email-minipli@googlemail.com>
	<20110610134821.GL24424@n2100.arm.linux.org.uk>
Date: Fri, 10 Jun 2011 15:53:24 +0200
Message-ID: <BANLkTimFL44XRDeA6z6pvKGw-zpcdsNUEw@mail.gmail.com>
Subject: Re: [PATCH] arm, exec: remove redundant set_fs(USER_DS)
From: Mathias Krause <minipli@googlemail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 3:48 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Fri, Jun 10, 2011 at 03:08:57PM +0200, Mathias Krause wrote:
>> The address limit is already set in flush_old_exec() so this
>> set_fs(USER_DS) is redundant.
>
> Please show where and how this is done.  I've looked and can't see
> any equivalent call to set_fs() in flush_old_exec().

Before dac853a (exec: delay address limit change until point of no
return) it was done in search_binary_handler(), now it is done in
flush_old_exec(). Either way set_fs(USER_DS) was/gets called before
start_thread() so the call there is redundant.

Mathias
