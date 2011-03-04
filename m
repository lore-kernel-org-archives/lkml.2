Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759989Ab1CDSZj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 13:25:39 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41682 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758463Ab1CDSZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 13:25:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=VuqRD5mdWFPzABQzxFDNOBSoSkO7Tp+dKEP2Bi/F86MZLjaqRNOJn7L78MqbeUACzb
         zDC+KoKfqbr+9JYQ2WnN1o1rK7AsCLaMS18J6TCBbl0k1bWsdwGC9LL8iFF3rARSIQGx
         BdicVyVe73LH6fqkfGnW9LXyKVkGJrpqxHp+A=
Date: Fri, 4 Mar 2011 21:17:49 +0300
From: Dan Carpenter <error27@gmail.com>
To: "J.P. Lacerda" <jp.lacerda@codethink.co.uk>
Cc: akpm@linux-foundation.org, johan.wessfeldt@gmail.com, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] x86: Fix mcheck_init_device() to handle
 misc_register() correctly
Message-ID: <20110304181749.GA3469@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	"J.P. Lacerda" <jp.lacerda@codethink.co.uk>,
	akpm@linux-foundation.org, johan.wessfeldt@gmail.com,
	tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
	linux-kernel@vger.kernel.org
References: <1299245367-20279-1-git-send-email-jp.lacerda@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299245367-20279-1-git-send-email-jp.lacerda@codethink.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 01:29:27PM +0000, J.P. Lacerda wrote:
> The return value for misc_register() was not being taken into account.
> Furthermore, if misc_register() fails, we must rollback any changes made by
> mcheck_init_device()
> 
> Signed-off-by: J.P. Lacerda <jp.lacerda@codethink.co.uk>

Ah...  You found a bug that Johan missed in his original patch.  But you
still left out the case where mce_create_device() can fail which his 
patch addressed.  Also his patch was nicer; using gotos to unwind is 
the standard way for kernel error handling.

Also why did you poach his patch without giving any kind of credit,
instead of just telling him about the bug???  WTF?

Johan, please fix add a free_cpumask_var(mce_dev_initialized); to your
patch.  Call it [PATCH v2].  Add in the changelog that J.P. Lacerda
told you about the missing free_cpumask_var(mce_dev_initialized).

regards,
dan carpenter


