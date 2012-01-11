Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933755Ab2AKRZl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 12:25:41 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:36102 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933643Ab2AKRZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 12:25:36 -0500
X-Authority-Analysis: v=2.0 cv=Pb19d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=TpKSeB6PbLgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=pGLkceISAAAA:8 a=M8fsvYSld6ZUBaevIWkA:9 a=p67wqnOF5lRkPUmpfIkA:7 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1326302732.7642.57.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 2/9] block: block_bio_complete tracepoint was missing
From: Steven Rostedt <rostedt@goodmis.org>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, mingo@redhat.com, fweisbec@gmail.com, teravest@google.com,
        slavapestov@google.com, ctalbott@google.com, dhsharp@google.com,
        linux-kernel@vger.kernel.org, winget@google.com, namhyung@gmail.com
Date: Wed, 11 Jan 2012 12:25:32 -0500
In-Reply-To: <1326220106-5765-3-git-send-email-tj@kernel.org>
References: <1326220106-5765-1-git-send-email-tj@kernel.org>
	 <1326220106-5765-3-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-10 at 10:28 -0800, Tejun Heo wrote:
> block_bio_complete tracepoint was defined but not invoked anywhere.
> Fix it.
> 
> -tj: This will generate duplicate BLK_TA_COMPLETEs.  Namhyung is
>      working on proper solution.
> 
> DO_NOT_APPLY
> Cc: Namhyung Kim <namhyung@gmail.com>
> ---
>  fs/bio.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/bio.c b/fs/bio.c
> index b1fe82c..96548da 100644
> --- a/fs/bio.c
> +++ b/fs/bio.c
> @@ -1447,6 +1447,9 @@ void bio_endio(struct bio *bio, int error)
>  	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
>  		error = -EIO;
>  
> +	if (bio->bi_bdev)
> +		trace_block_bio_complete(bdev_get_queue(bio->bi_bdev),
> +					 bio, error);

I thought I commented before about using TRACE_EVENT_CONDITIONAL() here.
To remove that open coded branch.

-- Steve

>  	if (bio->bi_end_io)
>  		bio->bi_end_io(bio, error);
>  }


