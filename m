Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026Ab2AZQ1J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 11:27:09 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59846 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666Ab2AZQ1H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 11:27:07 -0500
Message-ID: <1327595209.2446.117.camel@twins>
Subject: Re: [PATCH 5/9] perf: Add sysfs format attribute for pmu device
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Date: Thu, 26 Jan 2012 17:26:49 +0100
In-Reply-To: <1326717103-10287-6-git-send-email-jolsa@redhat.com>
References: <20120109152855.GA1597@m.brq.redhat.com>--suppress-cc=author>
	 <1326717103-10287-1-git-send-email-jolsa@redhat.com>
	 <1326717103-10287-6-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-16 at 13:31 +0100, Jiri Olsa wrote:
> Adding 'format' attribute for pmu device that contains
> a syntax description on how to construct raw events.
> 
> The event configuration is described in following
> struct pefr_event_attr attributes:
> 
>   config
>   config1
>   config2
> 
> Each line of the format file describes mapping of name
> and bitfield definition within one of abve attributes.
> 
> eg:
>   event   config:0-7
>   umask   config:8-15
>   usr     config:16
>   os      config:17
>   edge    config:18
>   any     config:21
>   inv     config:23
>   cmask   config:24-31
> 
> Line syntax:
>   line:      NAME config ':' bits
>   config:    'config' | 'config1' | 'config2"
>   bits:      bits ',' bit_term | bit_term
>   bit_term:  VALUE '-' VALUE | VALUE
> 
> Adding event_format callback to the struct pmu, which provides
> the format information. The pmu shall override this function
> and provide its own specific format information.
> 
> If not overloaded the default format information is used:
> 
>   config  config:0-63
>   config1 config1:0-63
>   config2 config2:0-63 

Shouldn't config[012] be hard-coded like period? They are struct
perf_event_attr members after all and it doesn't really make sense to
have them dynamic if we're going to have to add them to all pmu/format
things.


