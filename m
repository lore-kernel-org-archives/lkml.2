Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab2BBUQ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 15:16:59 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:33082 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468Ab2BBUQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 15:16:57 -0500
Message-ID: <1328213697.2342.154.camel@work-vm>
Subject: Re: [PATCH] merge_config.sh: Use the first file as the initial
 config
From: John Stultz <john.stultz@linaro.org>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Michal Marek <mmarek@suse.cz>, kernel-team@fedoraproject.org,
        linux-kernel@vger.kernel.org, Darren Hart <dvhart@linux.intel.com>
Date: Thu, 02 Feb 2012 12:14:57 -0800
In-Reply-To: <20120201170157.GA4907@zod.bos.redhat.com>
References: <20120201170157.GA4907@zod.bos.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020220-7182-0000-0000-000000A8B4FE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-01 at 12:01 -0500, Josh Boyer wrote:
> Take the first config fragment and use it verbatim as the initial config set.
> This avoids running the verification loop for the first file, as nothing has
> actually been merged at this point.  This significantly increases performance
> for large config fragments.
> 
> Signed-off-by: Josh Boyer <jwboyer@redhat.com>
> ---
> 
> When experimenting with merge_config.sh on the Fedora config fragments, this
> cut the execution time of a single invocation with all the config fragments
> in half (from 28 seconds to 13 seconds).

Adding Darren to the CC.

Nice! Looks ok to me.

Acked-by: John Stultz <john.stultz@linaro.org>

>  scripts/kconfig/merge_config.sh |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/kconfig/merge_config.sh b/scripts/kconfig/merge_config.sh
> index ceadf0e..23d738a 100644
> --- a/scripts/kconfig/merge_config.sh
> +++ b/scripts/kconfig/merge_config.sh
> @@ -58,12 +58,16 @@ while true; do
>  	esac
>  done
> 
> -
> +INITFILE=$1
> +shift;
> 
>  MERGE_LIST=$*
>  SED_CONFIG_EXP="s/^\(# \)\{0,1\}\(CONFIG_[a-zA-Z0-9_]*\)[= ].*/\2/p"
>  TMP_FILE=$(mktemp ./.tmp.config.XXXXXXXXXX)
> 
> +echo "Using $INITFILE as base"
> +cat $INITFILE > $TMP_FILE
> +
>  # Merge files, printing warnings on overrided values
>  for MERGE_FILE in $MERGE_LIST ; do
>  	echo "Merging $MERGE_FILE"


