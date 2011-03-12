Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086Ab1CQRxr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 13:53:47 -0400
Received: from outmail009.snc4.facebook.com ([66.220.144.141]:50185 "EHLO
	mx-out.facebook.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754854Ab1CQRxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 13:53:44 -0400
Date: Fri, 11 Mar 2011 17:31:25 -0800
From: Arun Sharma <asharma@fb.com>
To: Sam Liao <phyomh@gmail.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@redhat.com
Subject: Re: [PATCH] Add inverted call graph report support to perf tool
Message-ID: <20110312013125.GA24618@dev1756.snc6.facebook.com>
References: <AANLkTi=vxgHe=dqz+xEPcZ9oBexM1jBxFz3sXA2DJEZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=vxgHe=dqz+xEPcZ9oBexM1jBxFz3sXA2DJEZA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 09:43:27PM +0800, Sam Liao wrote:
> +
> +	/* reverse call chain data */
> +	if (reverse_call && symbol_conf.use_callchain && sample->callchain) {

You probably want to check for nr > 1 here, as in:

 	/* reverse call chain data */
-	if (reverse_call && symbol_conf.use_callchain && sample->callchain) {
+	if (reverse_call && symbol_conf.use_callchain && sample->callchain
+	    && (sample->callchain->nr > 1)) {
 		struct ip_callchain *chain;
 		int i, j;
 		u64 tmp_ip;

Otherwise, if you get a callchain with ->nr == 0, the loop with (nr - 2) will
go on for a long time.

 -Arun
