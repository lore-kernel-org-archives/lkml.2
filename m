Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722Ab1KIW0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 17:26:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49143 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443Ab1KIWZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 17:25:59 -0500
Date: Wed, 9 Nov 2011 14:25:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] Make dmi_name_in_vendors more focused
Message-Id: <20111109142557.70cb43cb.akpm@linux-foundation.org>
In-Reply-To: <20111104102647.0b3eba22@endymion.delvare>
References: <20111104102647.0b3eba22@endymion.delvare>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Nov 2011 10:26:47 +0100
Jean Delvare <khali@linux-fr.org> wrote:

> The current implementation of dmi_name_in_vendors() is an invitation
> to lazy coding and false positives [1]. Searching for a string in 8
> different DMI fields is something nobody should ever need to do. You
> know what you're looking for, so you should know where to look. strstr
> isn't fast, especially when it fails, so we should avoid calling it
> when it just can't succeed.
> 
> Looking at the current users of the function, it seems clear to me
> that they are looking for a system or board vendor name, so let's
> limit dmi_name_in_vendors to these two DMI fields. This much better
> matches the function name, BTW.
> 
> [1] We currently have code looking for short names in DMI data, such
> as "IBM" or "ASUS". I let you guess what will happen the day other
> vendors ship products named, for example, "SCHREIBMEISTER" or "PEGASUS".
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Cc: Andi Kleen <andi@firstfloor.org>
> ---
> This patch was already sent on 2011-05-15. I thought Andrew had picked
> it up but apparently not, otherwise it should already be upstream by
> now.

I did merge it in May and have carried it in -mm (and hence in
linux-next) since then.  I have sent it to Jesse at least twice, with
no effect.

I'll send it to Linus for 3.3-rc1, OK?
