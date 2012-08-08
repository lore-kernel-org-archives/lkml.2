Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759105Ab2HHT1A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 15:27:00 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:42378 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab2HHT07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 15:26:59 -0400
From: Paul Moore <paul@paul-moore.com>
To: John Stultz <johnstul@us.ibm.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, lkml <linux-kernel@vger.kernel.org>,
        James Morris <james.l.morris@oracle.com>, selinux@tycho.nsa.gov,
        Eric Dumazet <edumazet@google.com>, john.johansen@canonical.com
Subject: Re: NULL pointer dereference in selinux_ip_postroute_compat
Date: Wed, 08 Aug 2012 15:26:54 -0400
Message-ID: <17464273.DGOeQvDGIE@sifl>
User-Agent: KMail/4.9 (Linux/3.4.7-gentoo; KDE/4.9.0; x86_64; ; )
In-Reply-To: <5022BAA2.90606@us.ibm.com>
References: <50215A7E.8000701@linaro.org> <502198B4.8040503@linaro.org> <5022BAA2.90606@us.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 08, 2012 12:14:42 PM John Stultz wrote:
> So I bisected this down and it seems to be the following commit:
> 
> commit be9f4a44e7d41cee50ddb5f038fc2391cbbb4046
> Author: Eric Dumazet <edumazet@google.com>
> Date:   Thu Jul 19 07:34:03 2012 +0000
> 
>      ipv4: tcp: remove per net tcp_sock
> 
> 
> It doesn't revert totally cleanly, but after fixing up the rejections
> and booting with this patch removed on top of Linus' head the oops on
> shutdown goes away.

Thanks!

It looks the like there is a bug in ip_send_unicast_reply() which uses a 
inet_sock/sock struct which does not have the LSM data properly initialized. 

I'll put together a patch shortly.

-- 
paul moore
www.paul-moore.com

