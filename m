Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223Ab1AKOTs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 09:19:48 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51890 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932134Ab1AKOTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 09:19:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uovlzuGJ5WXd7c71HzoyVoufJ2Ya4wZ1gzoGjtevDAix1QlwxQru6ZeOWyRXBJ3ZQt
         /jx4abe5UmT34pxG1MPB3VcTZBTB8NtEXsw6HbnuJq8utiIa9Sg9YZ2DufFZCMhKIbKj
         ZHten8HYr96yKCb9AhuFkBHkkLEZrUIitLWUE=
Date: Tue, 11 Jan 2011 15:19:40 +0100
From: Tejun Heo <tj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org, brgerst@gmail.com, gorcunov@gmail.com,
        penberg@kernel.org, shaohui.zheng@intel.com
Subject: Re: [PATCH 04/16] x86: Replace cpu_2_logical_apicid[] with early
 percpu variable
Message-ID: <20110111141940.GB30607@htj.dyndns.org>
References: <1293731369-10851-1-git-send-email-tj@kernel.org>
 <1293731369-10851-5-git-send-email-tj@kernel.org>
 <alpine.DEB.2.00.1101101944320.16402@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1101101944320.16402@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 07:48:41PM -0800, David Rientjes wrote:
> On Thu, 30 Dec 2010, Tejun Heo wrote:
> 
> > Unlike x86_64, on x86_32, the mapping from cpu to logical apicid may
> > vary depending on apic in use.  cpu_2_logical_apicid[] array is used
> > for this mapping.  Replace it with early percpu variable
> > x86_cpu_to_logical_apicid to make it better aligned with other
> > mappings.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> 
> The apicid's are now stored as int's as opposed to u8, even though the max 
> is 256.  Is that for extendability or for better alignment?  If not, I 
> think it would be better to keep the old type.

I don't know.  Yeah, it's x86_32 only so it can be u8 but other IDs
are shared with x86_64 and should be int.  I think it's less confusing
to simply use int.  It's not like the extra overhead is gonna be
noticeable or anything.

Thanks.

-- 
tejun
