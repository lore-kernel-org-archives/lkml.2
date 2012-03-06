Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031597Ab2CGAA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 19:00:27 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:48058 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1031468Ab2CGAA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 19:00:26 -0500
X-IronPort-AV: E=Sophos;i="4.73,542,1325433600"; 
   d="scan'208";a="4472503"
Message-ID: <4F56A4E2.5050001@cn.fujitsu.com>
Date: Wed, 07 Mar 2012 07:59:30 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: Fujitsu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        eparis@parisplace.org
Subject: Re: [PATCH] selinux: init target class when add avc callback
References: <1328406808-11309-1-git-send-email-gaowanlong@cn.fujitsu.com>
In-Reply-To: <1328406808-11309-1-git-send-email-gaowanlong@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-07 07:58:29,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-07 07:58:29,
	Serialize complete at 2012-03-07 07:58:29
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2012 09:53 AM, Wanlong Gao wrote:

> Target security class should be initialized when add avc callback.
> Although tclass is userless in callbacks now, but it may be used
> in the future .
> 
> Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> ---
>  security/selinux/avc.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/security/selinux/avc.c b/security/selinux/avc.c
> index dca1c22..27495e6 100644
> --- a/security/selinux/avc.c
> +++ b/security/selinux/avc.c
> @@ -576,6 +576,7 @@ int avc_add_callback(int (*callback)(u32 event, u32 ssid, u32 tsid,
>  	c->events = events;
>  	c->ssid = ssid;
>  	c->tsid = tsid;
> +	c->tclass = tclass;
>  	c->perms = perms;
>  	c->next = avc_callbacks;
>  	avc_callbacks = c;


