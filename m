Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab0JMIcd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 04:32:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50133 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753309Ab0JMIcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 04:32:31 -0400
Message-ID: <4CB56E7F.3030908@cn.fujitsu.com>
Date: Wed, 13 Oct 2010 16:31:59 +0800
From: Shan Wei <shanwei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Yaogong Wang <ywang15@ncsu.edu>
CC: linux-sctp@vger.kernel.org, Vlad Yasevich <vladislav.yasevich@hp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 3/5] sctp: extend socket API for sched configuration
References: <AANLkTimEQkDpWorCF4HUq6N-xAnFz4xE89osAtcJY_Mn@mail.gmail.com>
In-Reply-To: <AANLkTimEQkDpWorCF4HUq6N-xAnFz4xE89osAtcJY_Mn@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yaogong Wang wrote, at 09/12/2010 09:13 AM:
> Augment SCTP socket API with a new socket option SCTP_SCHED
> to choose and configure multistream scheduling algorithm.
> 
> Signed-off-by: Yaogong Wang <ywang15@ncsu.edu>
> ---
>  include/net/sctp/structs.h |    4 ++
>  include/net/sctp/user.h    |   19 ++++++++++
>  net/sctp/outqueue.c        |    4 ++
>  net/sctp/sm_sideeffect.c   |   45 +++++++++++++++++++++++--
>  net/sctp/socket.c          |   80 ++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 149 insertions(+), 3 deletions(-)
> 
> diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
> index 52af764..1a76417 100644
> --- a/include/net/sctp/structs.h
> +++ b/include/net/sctp/structs.h
> @@ -333,6 +333,8 @@ struct sctp_sock {
> 
>  	/* Multistream scheduling */
>  	const struct sctp_sched_ops *sched_ops;
> +	__u16 sched_config_len;
> +	void *sched_config;
> 
>  	struct sctp_initmsg initmsg;
>  	struct sctp_rtoinfo rtoinfo;
> @@ -1173,6 +1175,8 @@ struct sctp_outq {
> 
>  	/* Multistream scheduling */
>  	const struct sctp_sched_ops *sched_ops;
> +	__u16 sched_config_len;
> +	void *sched_config;

Why did you take these two fields into sctp_sock and sctp_outq?
These two fields between sctp_sock and sctp_outq has same role,
we can only defined in one place.
How about using sctp_sk(sctp_outq->asoc->base.sk) to access these two
fields?


-- 
Best Regards
-----
Shan Wei
