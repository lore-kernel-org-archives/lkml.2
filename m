Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932670Ab1C3OlH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 10:41:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37437 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932599Ab1C3OlF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 10:41:05 -0400
Subject: Re: [PATCH] perf: Rebase max unprivileged mlock threshold on top
 of page size
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Stable <stable@kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
In-Reply-To: <1301493870-4551-1-git-send-email-fweisbec@gmail.com>
References: <1301065512.2250.223.camel@laptop>
	 <1301493870-4551-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 30 Mar 2011 16:40:28 +0200
Message-ID: <1301496028.4859.183.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-30 at 16:04 +0200, Frederic Weisbecker wrote:
> +int sysctl_perf_event_mlock __read_mostly = (129 * PAGE_SIZE) / 1024; /* 'free' kb per user */

I'm fairly sure you don't want to do this either: 
  512 + (PAGE_SIZE / 1024)
should do I think, there's no reason to further inflate things for large
page platforms.
