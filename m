Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031280Ab2HGWxQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:53:16 -0400
Received: from nm16-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.19]:43781
	"HELO nm16-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1031209Ab2HGWxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:53:12 -0400
X-Yahoo-Newman-Id: 12980.19576.bm@smtp110.biz.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: wXzFY3EVM1nCR_iWOumCBX5tJxvUU6uhJktjcMfUtdoCjF8
 fJnu1LIq94e4KuEWg.HPsQW4HybfLk_0PqfYOhXGdlrObOHC2O64ad5CdTf1
 PFlH1MzJAZshS99.RcBxEffy20Pi7S.WghXsPKLF6pDpKiNEp5e8DED.9bQH
 NzTdkPwa21UYyRnwxIQlYm5dhRXphO5naEj_XlIpUjpzfcH9AJYIGMJ8ImSy
 2pruaEGP6.w2ka83KhHO9f7x4brFhvghyCHiWyCRn8kOdDzIYofgJy0KAT4p
 fjfSJ554PCMykeLTKsXKzSQPW39.XaY8L_mACXl0XxjvLx_wgpUaTcoOmpQy
 TxsGukA5oOfb65QFKRFZqMvHIFpaUphH2KhyyXq88lllIDSvReuJf90Vt17M
 JKQe8uf705za0Fh5Kk01FBUkAuETAnFQsy3w2j5Z0qQJ2O03L1Vp0.83B
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <50219C55.8030400@schaufler-ca.com>
Date: Tue, 07 Aug 2012 15:53:09 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Cox <alan@linux.intel.com>,
        James Morris <james.l.morris@oracle.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [ 010/122] smack: off by one error
References: <20120807221948.220495155@linuxfoundation.org> <20120807221949.167564072@linuxfoundation.org>
In-Reply-To: <20120807221949.167564072@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/7/2012 3:24 PM, Greg Kroah-Hartman wrote:
> From: Greg KH <gregkh@linuxfoundation.org>
>
> 3.5-stable review patch.  If anyone has any objections, please let me know.

No objection here.

>
> ------------------
>
> From: Alan Cox <alan@linux.intel.com>
>
> commit 3b9fc37280c521b086943f9aedda767f5bf3b2d3 upstream.
>
> Consider the input case of a rule that consists entirely of non space
> symbols followed by a \0. Say 64 + \0
>
> In this case strlen(data) = 64
> kzalloc of subject and object are 64 byte objects
> sscanfdata, "%s %s %s", subject, ...)
>
> will put 65 bytes into subject.
>
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> Acked-by: Casey Schaufler <casey@schaufler-ca.com>
> Signed-off-by: James Morris <james.l.morris@oracle.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> ---
>  security/smack/smackfs.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> --- a/security/smack/smackfs.c
> +++ b/security/smack/smackfs.c
> @@ -325,11 +325,11 @@ static int smk_parse_long_rule(const cha
>  	int datalen;
>  	int rc = -1;
>  
> -	/*
> -	 * This is probably inefficient, but safe.
> -	 */
> +	/* This is inefficient */
>  	datalen = strlen(data);
> -	subject = kzalloc(datalen, GFP_KERNEL);
> +
> +	/* Our first element can be 64 + \0 with no spaces */
> +	subject = kzalloc(datalen + 1, GFP_KERNEL);
>  	if (subject == NULL)
>  		return -1;
>  	object = kzalloc(datalen, GFP_KERNEL);
>
>
>

