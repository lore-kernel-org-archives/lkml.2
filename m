Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab1AKDtA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 22:49:00 -0500
Received: from smtp-out.google.com ([216.239.44.51]:34378 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370Ab1AKDsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 22:48:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=I4nHan40tTQ5/+eZXR+0Yd6IJt5PswG4BvVj3FIhfHn5gEEed+g1ccJ3AuHpyQrCEx
         76fcyFGpKspRFE+Znq8Q==
Date: Mon, 10 Jan 2011 19:48:41 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org, brgerst@gmail.com, gorcunov@gmail.com,
        penberg@kernel.org, shaohui.zheng@intel.com
Subject: Re: [PATCH 04/16] x86: Replace cpu_2_logical_apicid[] with early
 percpu variable
In-Reply-To: <1293731369-10851-5-git-send-email-tj@kernel.org>
Message-ID: <alpine.DEB.2.00.1101101944320.16402@chino.kir.corp.google.com>
References: <1293731369-10851-1-git-send-email-tj@kernel.org> <1293731369-10851-5-git-send-email-tj@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Dec 2010, Tejun Heo wrote:

> Unlike x86_64, on x86_32, the mapping from cpu to logical apicid may
> vary depending on apic in use.  cpu_2_logical_apicid[] array is used
> for this mapping.  Replace it with early percpu variable
> x86_cpu_to_logical_apicid to make it better aligned with other
> mappings.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

The apicid's are now stored as int's as opposed to u8, even though the max 
is 256.  Is that for extendability or for better alignment?  If not, I 
think it would be better to keep the old type.
