Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab2ECOpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 10:45:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753871Ab2ECOpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 10:45:43 -0400
Message-ID: <4FA29A00.3040303@gmail.com>
Date: Thu, 03 May 2012 16:45:20 +0200
From: Edward Shishkin <edward.shishkin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: reiserfs-devel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs/reiserfs/journal.c: add missing brelse
References: <1336054373-13293-1-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1336054373-13293-1-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2012 04:12 PM, Julia Lawall wrote:
> From: Julia Lawall<Julia.Lawall@lip6.fr>
>
> Brelse is called to put bhjh on every way out of the function except this one.

Yes, thanks.
Acked-by: Edward Shishkin <edward.shishkin@gmail.com>

>
> Signed-off-by: Julia Lawall<Julia.Lawall@lip6.fr>
>
> ---
>   fs/reiserfs/journal.c |    4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
> index b1a0857..1ef9cbc 100644
> --- a/fs/reiserfs/journal.c
> +++ b/fs/reiserfs/journal.c
> @@ -2757,8 +2757,10 @@ int journal_init(struct super_block *sb, const char *j_dev_name,
>   	    le32_to_cpu(jh->jh_journal.jp_journal_max_commit_age);
>   	journal->j_max_trans_age = JOURNAL_MAX_TRANS_AGE;
>
> -	if (check_advise_trans_params(sb, journal) != 0)
> +	if (check_advise_trans_params(sb, journal) != 0) {
> +		brelse(bhjh);
>   	        goto free_and_return;
> +	}
>   	journal->j_default_max_commit_age = journal->j_max_commit_age;
>
>   	if (commit_max_age != 0) {
>
> --
> To unsubscribe from this list: send the line "unsubscribe reiserfs-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

