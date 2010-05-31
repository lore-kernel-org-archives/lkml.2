Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab0EaNnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 09:43:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46524 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547Ab0EaNnp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 09:43:45 -0400
Subject: Re: [RFC] perf, x86: Segregate PMU workaraunds into
 x86_pmu_quirk_ops structure
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100531130058.GR21799@erda.amd.com>
References: <20100529182409.GJ5322@lenovo>
	 <20100531130058.GR21799@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 31 May 2010 15:43:47 +0200
Message-ID: <1275313427.27810.22792.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-31 at 15:00 +0200, Robert Richter wrote:
> 
> The quirk functions add additional code and ops structures to the
> already existing model specific code. This quirks would be fine if we
> would could merge model specific code and get unified code. But these
> model specific code cannot be replaced. So I rather prefer to
> implement cpu errata in model specific code.

The reason the existing quirk() function is called after *_pmu_init() is
because of the funny way it all writes to the console.


