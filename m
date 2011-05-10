Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932674Ab1EJOsK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 10:48:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40862 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539Ab1EJOr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 10:47:59 -0400
Subject: Re: [PATCH 3/3] perf, tools: Add support for guest/host-only
 profiling
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
In-Reply-To: <1305038132-5080-4-git-send-email-joerg.roedel@amd.com>
References: <1305038132-5080-1-git-send-email-joerg.roedel@amd.com>
	 <1305038132-5080-4-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 May 2011 16:50:08 +0200
Message-ID: <1305039008.2914.98.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-10 at 16:35 +0200, Joerg Roedel wrote:
> @@ -740,6 +740,12 @@ parse_event_modifier(const char **strp, struct perf_event_attr *attr)
>                         if (!exclude)
>                                 exclude = eu = ek = eh = 1;
>                         eh = 0;
> +               } else if (*str == 'G') {
> +                       eg   = 0;
> +                       ehst = 1;
> +               } else if (*str == 'H') {
> +                       eg   = 1;
> +                       ehst = 0; 

This doesn't match the existing exclude logic, also eH and eG come to mind.

