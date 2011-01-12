Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab1ALSFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 13:05:31 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34158 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755205Ab1ALSF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 13:05:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=BvsZWu/B9G1O0JNsPHcAISdmpdMheZBox1TpQmy6V9XflcUlK5jdXt6W5keuf+IYAS
         uQZ9sT1uXKq3tZuJKNBCdgDIMzEP041YMB050pk8k04MkcrNl1xSZDFyG+YKEWF8D8Xo
         fQVQsxiord6WH5yEHDu+oWGWip3SDJR6F/jfo=
Subject: Re: [PATCH v1 1/2] TCPCT API sysctl update to draft -03
From: Eric Dumazet <eric.dumazet@gmail.com>
To: William Allen Simpson <william.allen.simpson@gmail.com>
Cc: Linux Kernel Developers <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4D2DEA73.4000708@gmail.com>
References: <4D2DE824.10205@gmail.com>  <4D2DEA73.4000708@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Jan 2011 19:05:25 +0100
Message-ID: <1294855525.3981.119.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 12 janvier 2011 à 12:52 -0500, William Allen Simpson a
écrit :
> Use most recently specified symbols of RFC-to-be-6013.
> 
> Allows different global s_data limits for SYN and SYN_ACK.
> 
> CC: "Eric W. Biederman" <ebiederm@xmission.com>
> CC: Stephen Hemminger <shemminger@vyatta.com>
> CC: Andi Kleen <andi@firstfloor.org>


> Signed-off-by: William.Allen.Simpson@gmail.com

Should be :

Signed-off-by: William Allen Simpson <William.Allen.Simpson@gmail.com>

> ---
>   Documentation/networking/ip-sysctl.txt |   10 ++++++++++
>   include/net/tcp.h                      |    2 ++
>   net/ipv4/sysctl_net_ipv4.c             |   25 ++++++++++++++++++++++++-
>   net/ipv4/tcp_output.c                  |   19 +++++++++++++++++--
>   4 files changed, 53 insertions(+), 3 deletions(-)

Hmm, patch is not inlined, so I have to copy/paste

+static int tcp_cookie_max = TCP_COOKIE_MAX;

...
 
 /* Update system visible IP port range */
 static void set_local_port_range(int range[2])
@@ -588,7 +591,27 @@ static struct ctl_table ipv4_table[] = {
                .data           = &sysctl_tcp_cookie_size,
                .maxlen         = sizeof(int),
                .mode           = 0644,
-               .proc_handler   = proc_dointvec
+               .proc_handler   = proc_dointvec_minmax,
+               .extra1         = &zero,
+               .extra2         = &tcp_cookie_max,
+       },


Now sysctl_tcp_cookie_size has a max limit of TCP_COOKIE_MAX, you can
remove the now uneeded check in :

static u8 tcp_cookie_size_check(u8 desired)
...
if (cookie_size >= TCP_COOKIE_MAX)
	/* value too large, specify maximum */
	return TCP_COOKIE_MAX;



