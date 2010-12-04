Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab0LDBxB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 20:53:01 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:55439 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137Ab0LDBxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 20:53:00 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=Of1ChBLq4JMA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1XWaLZrsAAAA:8 a=hu0TL-BFrgT-TbDs3LwA:9 a=EFAZ54PDLAQsVOeg7Jwv17APa-UA:4 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 10/15] ftrace: fix event alignment: jbd2:*
From: Steven Rostedt <rostedt@goodmis.org>
To: David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org, mrubin@google.com,
        "Theodore Ts'o" <tytso@mit.edu>
In-Reply-To: <1291421609-14665-11-git-send-email-dhsharp@google.com>
References: <1291421609-14665-1-git-send-email-dhsharp@google.com>
	 <1291421609-14665-11-git-send-email-dhsharp@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 03 Dec 2010 20:52:58 -0500
Message-ID: <1291427578.16223.12.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Ccing Ted for Acked-by ]

-- Steve


On Fri, 2010-12-03 at 16:13 -0800, David Sharp wrote:
> Signed-off-by: David Sharp <dhsharp@google.com>
> ---
>  include/trace/events/jbd2.h |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/include/trace/events/jbd2.h b/include/trace/events/jbd2.h
> index 7447ea9..2f9f362 100644
> --- a/include/trace/events/jbd2.h
> +++ b/include/trace/events/jbd2.h
> @@ -41,15 +41,15 @@ DECLARE_EVENT_CLASS(jbd2_commit,
>  	TP_STRUCT__entry(
>  		__field(	int,   dev_major                )
>  		__field(	int,   dev_minor                )
> -		__field(	char,	sync_commit		  )
>  		__field(	int,	transaction		  )
> +		__field(	char,	sync_commit		  )
>  	),
>  
>  	TP_fast_assign(
>  		__entry->dev_major	= MAJOR(journal->j_fs_dev->bd_dev);
>  		__entry->dev_minor	= MINOR(journal->j_fs_dev->bd_dev);
> -		__entry->sync_commit = commit_transaction->t_synchronous_commit;
>  		__entry->transaction	= commit_transaction->t_tid;
> +		__entry->sync_commit = commit_transaction->t_synchronous_commit;
>  	),
>  
>  	TP_printk("dev %d,%d transaction %d sync %d",
> @@ -93,17 +93,17 @@ TRACE_EVENT(jbd2_end_commit,
>  	TP_STRUCT__entry(
>  		__field(	int,   dev_major                )
>  		__field(	int,   dev_minor                )
> -		__field(	char,	sync_commit		  )
>  		__field(	int,	transaction		  )
>  		__field(	int,	head		  	  )
> +		__field(	char,	sync_commit		  )
>  	),
>  
>  	TP_fast_assign(
>  		__entry->dev_major	= MAJOR(journal->j_fs_dev->bd_dev);
>  		__entry->dev_minor	= MINOR(journal->j_fs_dev->bd_dev);
> -		__entry->sync_commit = commit_transaction->t_synchronous_commit;
>  		__entry->transaction	= commit_transaction->t_tid;
>  		__entry->head		= journal->j_tail_sequence;
> +		__entry->sync_commit = commit_transaction->t_synchronous_commit;
>  	),
>  
>  	TP_printk("dev %d,%d transaction %d sync %d head %d",


