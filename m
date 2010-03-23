Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466Ab0CWLHg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 07:07:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54461 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752412Ab0CWLHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 07:07:32 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Borislav Petkov <bp@amd64.org>
Subject: Re: [PATCH 1/5] cpufreq: Unify sysfs attribute definition macros
Date: Tue, 23 Mar 2010 12:07:29 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.1-desktop; KDE/4.3.5; x86_64; ; )
Cc: akpm@linux-foundation.org, davej@redhat.com, cpufreq@vger.kernel.org,
       x86@kernel.org, linux-kernel@vger.kernel.org
References: <1269283121-11894-1-git-send-email-bp@amd64.org> <1269283121-11894-2-git-send-email-bp@amd64.org>
In-Reply-To: <1269283121-11894-2-git-send-email-bp@amd64.org>
MIME-Version: 1.0
X-Length: 2251
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201003231207.29230.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 March 2010 19:38:37 Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Multiple modules used to define those which are with identical
> functionality and were needlessly replicated among the different cpufreq
> drivers. Push them into the header and remove duplication.
> 
...
> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> index 4de02b1..c8d731c 100644
> --- a/include/linux/cpufreq.h
> +++ b/include/linux/cpufreq.h
> @@ -278,6 +278,27 @@ struct freq_attr {
>  	ssize_t (*store)(struct cpufreq_policy *, const char *, size_t count);
>  };
...
>  
> +#define define_one_global_ro(_name)		\
> +static struct global_attr _name =		\
> +__ATTR(_name, 0444, show_##_name, NULL)
> +
> +#define define_one_global_rw(_name)		\
> +static struct global_attr _name =		\
> +__ATTR(_name, 0644, show_##_name, store_##_name)

These sound like too general names in global space.
And are unrelated to cpufreq(.h).
Eventually you get them into sysfs.h with another name
or just duplicate them?

   Thomas
