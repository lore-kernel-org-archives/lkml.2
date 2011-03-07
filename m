Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124Ab1CGX1D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 18:27:03 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59783 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982Ab1CGX1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 18:27:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZTYV7L4RZY/cAV/IpkHlpwMpg1ABt//qTrySdnINiPxVX71EuHL6eQtdHMwZvE9WHG
         4+PZeiODmDcmzn24LvUeF1h6lZs8RB7Ckme9S7Jwo26tRW1SD1dDawKphfTluy+9RD3U
         jH/xZT1B7FjbOLU4oU6H3OIyhRRhQSvrCbvQs=
Date: Tue, 8 Mar 2011 01:26:55 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, hidave.darkstar@gmail.com
Subject: Re: + sysctl-add-proc_dointvec_unsigned-handler.patch added to -mm
 tree
Message-ID: <20110307232655.GA7234@p183.telecom.by>
References: <201103072305.p27N5hKT000474@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103072305.p27N5hKT000474@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 03:05:43PM -0800, akpm@linux-foundation.org wrote:
> Add a proc_dointvec_unsigned() sysctl handler for positive value cases.

> --- a/kernel/sysctl.c~sysctl-add-proc_dointvec_unsigned-handler
> +++ a/kernel/sysctl.c

> +int proc_dointvec_unsigned(struct ctl_table *table, int write,
> +		  void __user *buffer, size_t *lenp, loff_t *ppos)
> +{
> +	struct do_proc_dointvec_minmax_conv_param param = {
> +		.min = &zero,
> +	};
> +	return do_proc_dointvec(table, write, buffer, lenp, ppos,
> +				do_proc_dointvec_minmax_conv, &param);
> +}

This silently ignored max value in .extra2 .
