Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab2FERnj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 13:43:39 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:50551 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129Ab2FERnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 13:43:37 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Wanpeng Li <liwp.linux@gmail.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Rob Landley <rob@landley.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan.kim@gmail.com>,
        David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>, Ingo Molnar <mingo@elte.hu>,
        Michel Lespinasse <walken@google.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Wanpeng Li <liwp@linux.vnet.ibm.com>
References: <1338888276-3341-1-git-send-email-liwp.linux@gmail.com>
Date: Tue, 05 Jun 2012 10:43:02 -0700
In-Reply-To: <1338888276-3341-1-git-send-email-liwp.linux@gmail.com> (Wanpeng
	Li's message of "Tue, 5 Jun 2012 17:24:36 +0800")
Message-ID: <87fwa964ex.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18KjchTDlPAVXjKx7ciAxxrCHhj1UOjMSU=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.0 XMBody_17 BODY: Spammy words in all caps
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0002]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.1 XMSolicitRefs_0 Weightloss drug
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Wanpeng Li <liwp.linux@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] remove no longer use of pdflush interface
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wanpeng Li <liwp.linux@gmail.com> writes:

> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
>
> ------------------
>
> Change in v2:
>
> * add printk warning
> * add description in Documentation

Do we have old distributions or other users commonly using
nr_pdflush_threads?

Otherwise we should just remove the tunable as it is a big complicated
no-op.

If someone is using it we need to do the entire rate limited warning
thing.  You should at least use printk_ratelimit to keep someone from
dosing the system by writing to the file too fast.

Eric

> ------------------
>
> Signed-off-by: Wanpeng Li <liwp@linux.vnet.ibm.com>
> ---
>  .../ABI/obsolete/proc-sys-vm-nr_pdflush_threads    |    5 +++++
>  Documentation/feature-removal-schedule.txt         |    8 ++++++++
>  Documentation/sysctl/vm.txt                        |   11 -----------
>  fs/fs-writeback.c                                  |    5 -----
>  include/linux/sysctl.h                             |    3 +++
>  include/linux/writeback.h                          |    5 -----
>  kernel/sysctl.c                                    |   18 +++++++++++++-----
>  kernel/sysctl_binary.c                             |    2 +-
>  8 files changed, 30 insertions(+), 27 deletions(-)
>  create mode 100644 Documentation/ABI/obsolete/proc-sys-vm-nr_pdflush_threads
>
> diff --git a/Documentation/ABI/obsolete/proc-sys-vm-nr_pdflush_threads b/Documentation/ABI/obsolete/proc-sys-vm-nr_pdflush_threads
> new file mode 100644
> index 0000000..edbe548
> --- /dev/null
> +++ b/Documentation/ABI/obsolete/proc-sys-vm-nr_pdflush_threads
> @@ -0,0 +1,5 @@
> +What:		/proc/sys/vm/nr_pdflush_threads
> +Date:		June 2012
> +Contact:	Wanpeng Li <liwp@linux.vnet.ibm.com>
> +Description: Since pdflush is replaced by per-BDI flusher, the interface of old pdflush
> +             exported in /proc/sys/vm/ should be removed.
> diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
> index e4b5775..7eea1ee 100644
> --- a/Documentation/feature-removal-schedule.txt
> +++ b/Documentation/feature-removal-schedule.txt
> @@ -6,6 +6,14 @@ be removed from this file.
>  
>  ---------------------------
>  
> +What: /proc/sys/vm/nr_pdflush_threads
> +When: 2012
> +Why: Since pdflush is deprecated, the interface exported in /proc/sys/vm/
> +     should be removed.
> +Who: Wanpeng Li <liwp@linux.vnet.ibm.com>
> +
> +---------------------------
> +
>  What:	CONFIG_APM_CPU_IDLE, and its ability to call APM BIOS in idle
>  When:	2012
>  Why:	This optional sub-feature of APM is of dubious reliability,
> diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
> index 96f0ee8..71c17d2 100644
> --- a/Documentation/sysctl/vm.txt
> +++ b/Documentation/sysctl/vm.txt
> @@ -42,7 +42,6 @@ Currently, these files are in /proc/sys/vm:
>  - mmap_min_addr
>  - nr_hugepages
>  - nr_overcommit_hugepages
> -- nr_pdflush_threads
>  - nr_trim_pages         (only if CONFIG_MMU=n)
>  - numa_zonelist_order
>  - oom_dump_tasks
> @@ -426,16 +425,6 @@ See Documentation/vm/hugetlbpage.txt
>  
>  ==============================================================
>  
> -nr_pdflush_threads
> -
> -The current number of pdflush threads.  This value is read-only.
> -The value changes according to the number of dirty pages in the system.
> -
> -When necessary, additional pdflush threads are created, one per second, up to
> -nr_pdflush_threads_max.
> -
> -==============================================================
> -
>  nr_trim_pages
>  
>  This is available only on NOMMU kernels.
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 539f36c..30ddb8a 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -52,11 +52,6 @@ struct wb_writeback_work {
>  	struct completion *done;	/* set if the caller waits */
>  };
>  
> -/*
> - * We don't actually have pdflush, but this one is exported though /proc...
> - */
> -int nr_pdflush_threads;
> -
>  /**
>   * writeback_in_progress - determine whether there is writeback in progress
>   * @bdi: the device's backing_dev_info structure.
> diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
> index c34b4c8..f25be74 100644
> --- a/include/linux/sysctl.h
> +++ b/include/linux/sysctl.h
> @@ -964,6 +964,9 @@ extern int proc_doulongvec_ms_jiffies_minmax(struct ctl_table *table, int,
>  				      void __user *, size_t *, loff_t *);
>  extern int proc_do_large_bitmap(struct ctl_table *, int,
>  				void __user *, size_t *, loff_t *);
> +extern int proc_deprecated(struct ctl_table *, int,
> +				void __user *, size_t *, loff_t *);
> +
>  
>  /*
>   * Register a set of sysctl names by calling register_sysctl_table
> diff --git a/include/linux/writeback.h b/include/linux/writeback.h
> index a2b84f5..13b5df7 100644
> --- a/include/linux/writeback.h
> +++ b/include/linux/writeback.h
> @@ -193,9 +193,4 @@ void tag_pages_for_writeback(struct address_space *mapping,
>  
>  void account_page_redirty(struct page *page);
>  
> -/* pdflush.c */
> -extern int nr_pdflush_threads;	/* Global so it can be exported to sysctl
> -				   read-only. */
> -
> -
>  #endif		/* WRITEBACK_H */
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 4ab1187..1ab53cb 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -1095,11 +1095,9 @@ static struct ctl_table vm_table[] = {
>  		.extra1		= &zero,
>  	},
>  	{
> -		.procname	= "nr_pdflush_threads",
> -		.data		= &nr_pdflush_threads,
> -		.maxlen		= sizeof nr_pdflush_threads,
> -		.mode		= 0444 /* read-only*/,
> -		.proc_handler	= proc_dointvec,
> +		.procname       = "nr_pdflush_threads",
> +		.mode           = 0444 /* read-only */,
> +		.proc_handler   = proc_deprecated,
>  	},
>  	{
>  		.procname	= "swappiness",
> @@ -2505,6 +2503,15 @@ int proc_doulongvec_ms_jiffies_minmax(struct ctl_table *table, int write,
>  
>  #endif /* CONFIG_PROC_SYSCTL */
>  
> +/* notice associated proc deprecated */
> +int proc_deprecated(struct ctl_table *table, int write,
> +		    void __user *buffer, size_t *lenp, loff_t *ppos)
> +{
> +	printk(KERN_WARNING "%s exported in /proc is deprecated\n",
> +			table->procname);
> +	return -ENOSYS;
> +}
> +
>  /*
>   * No sense putting this after each symbol definition, twice,
>   * exception granted :-)
> @@ -2517,3 +2524,4 @@ EXPORT_SYMBOL(proc_dointvec_ms_jiffies);
>  EXPORT_SYMBOL(proc_dostring);
>  EXPORT_SYMBOL(proc_doulongvec_minmax);
>  EXPORT_SYMBOL(proc_doulongvec_ms_jiffies_minmax);
> +EXPORT_SYMBOL(proc_deprecated);
> diff --git a/kernel/sysctl_binary.c b/kernel/sysctl_binary.c
> index a650694..65bdcf1 100644
> --- a/kernel/sysctl_binary.c
> +++ b/kernel/sysctl_binary.c
> @@ -147,7 +147,7 @@ static const struct bin_table bin_vm_table[] = {
>  	{ CTL_INT,	VM_DIRTY_RATIO,			"dirty_ratio" },
>  	/* VM_DIRTY_WB_CS "dirty_writeback_centisecs" no longer used */
>  	/* VM_DIRTY_EXPIRE_CS "dirty_expire_centisecs" no longer used */
> -	{ CTL_INT,	VM_NR_PDFLUSH_THREADS,		"nr_pdflush_threads" },
> +	/* VM_NR_PDFLUSH_THREADS "nr_pdflush_threads" no longer used */
>  	{ CTL_INT,	VM_OVERCOMMIT_RATIO,		"overcommit_ratio" },
>  	/* VM_PAGEBUF unused */
>  	/* VM_HUGETLB_PAGES "nr_hugepages" no longer used */
