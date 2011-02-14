Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab1BNL3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 06:29:39 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51832 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556Ab1BNL3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 06:29:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GF99Luw2LaFI0gxmYQtJYTtovot1Ny8J9plhCoMntNnOtrqIQ9kq98CYlI0X1WDPH6
         A/D+gBkbalKqfBqZru9OpLFz0QvLSBLOD5SsZtUFKCW00VmHA1Qr4GKbAdW0qaohzqre
         UWsIJvEwqouMFgrvhv5ZIqpwKRmy5+4GymxmY=
Date: Mon, 14 Feb 2011 12:29:31 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, brgerst@gmail.com,
        gorcunov@gmail.com, shaohui.zheng@intel.com, rientjes@google.com,
        mingo@elte.hu, hpa@linux.intel.com
Subject: Re: [PATCH 04/26] x86-64, NUMA: Unify
 {acpi|amd}_{numa_init|scan_nodes}() arguments and return values
Message-ID: <20110214112931.GF18742@htj.dyndns.org>
References: <1297530663-26234-1-git-send-email-tj@kernel.org>
 <1297530663-26234-5-git-send-email-tj@kernel.org>
 <4D56D3C7.8050803@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D56D3C7.8050803@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 12, 2011 at 10:39:03AM -0800, Yinghai Lu wrote:
> > @@ -297,7 +297,10 @@ int __init acpi_numa_init(void)
> >  	acpi_table_parse(ACPI_SIG_SLIT, acpi_parse_slit);
> >  
> >  	acpi_numa_arch_fixup();
> > -	return ret;
> > +
> > +	if (cnt <= 0)
> > +		return cnt ?: -ENOENT;
> > +	return 0;
> >  }
> >  
> >  int acpi_get_pxm(acpi_handle h)
> 
> 
> it will break AMD system that does not have SRAT.
> 
> your change will treat NO_SRAT as SRAT is there.

Can you please elaborate a bit?  Yinghai, there's brevity and there's
being cryptic.  I appreciate your reviews but don't want to spend time
trying to decipher what you mean.  If it doesn't hurt your fingers too
much, please put a bit more effort into explaining.

Thank you.

-- 
tejun
