Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461Ab0KCUDt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 16:03:49 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38026 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab0KCUDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 16:03:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=DZHrQkDl2jD29KdwYRjwKdmQ/WPmr63R3uuGs2ddm+kCnP3LrAgTa60aRyHwZNT1u9
         YL3UDNdNyjAypDcvOQav4/dnyNHxM3Bj1BNsIMZ2To1QRyL5nnkd/oD9gUjiP+bmh69m
         CW5L1JQPiYJRMOf0ybQg8jSJ7gdDJKggdyQJY=
Message-ID: <4CD1C01E.1010309@gmail.com>
Date: Wed, 03 Nov 2010 21:03:42 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Dr. Werner Fink" <werner@suse.de>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 1/1] console: add /proc/consoles
References: <1288798509-23550-1-git-send-email-jslaby@suse.cz> <20101103161342.GA4942@suse.de> <4CD18ACB.4060108@suse.cz> <20101103162251.GA5404@suse.de> <4CD18CFC.7080100@suse.cz> <20101103173944.GA6589@suse.de>
In-Reply-To: <20101103173944.GA6589@suse.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2010 06:39 PM, Greg KH wrote:
> On Wed, Nov 03, 2010 at 05:25:32PM +0100, Jiri Slaby wrote:
>> Actually where this code should be in fs/proc/? Most of the /proc/* is
>> handled elsewhere (fs/ mm/ kernel/). The rest is handled in specialized
>> fs/proc/FILE.c.
> 
> What's wrong with putting it into fs/proc/proc_tty.c?  That seems like
> the most logical thing to me...

consoles have little to do with ttys. Except ttys can be consoles. To me
it seems illogical to have info about netconsole, parallel consoles or
early serials somewhere in /proc/tty/. That's why I moved the info from
/proc/tty/ to /proc and the code from fs/proc/proc_tty.c to
kernel/printk.c where consoles are managed.

But if that makes less sense now than it did before, I will happily
switch it back.

regards,
-- 
js
