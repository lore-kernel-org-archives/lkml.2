Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab0FPOy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 10:54:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44688 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab0FPOy0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 10:54:26 -0400
Subject: Re: [RFC] perf/perf_events: misleading number of samples due to
 mmap()
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
       eranian@gmail.com
In-Reply-To: <AANLkTikvExLi_MahU3kkX1TQKvBODq8SyTSXgpyAjOay@mail.gmail.com>
References: <AANLkTikvExLi_MahU3kkX1TQKvBODq8SyTSXgpyAjOay@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 16 Jun 2010 16:54:12 +0200
Message-ID: <1276700052.1745.600.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-16 at 16:40 +0200, Stephane Eranian wrote:
> The reason is that perf reports an estimate based on the
> number of bytes written to the buffer divided by the minimal
> sample size of 24 bytes. 

Right, we should change that based on the PERF_SAMPLE flags used. It
will remain an estimate due to the out of band events, but it should be
closer than assuming the minimal sample size.
