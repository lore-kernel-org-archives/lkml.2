Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760597Ab0FKVEI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 17:04:08 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33812 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760548Ab0FKVEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 17:04:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wQqEecaUvBwv9hoKO2B/IPPrbZ9VIhQ6Oeq2W652c+zdkNn9YdNAu+xgIlM/ykO7wS
         VP5xsVRBLojKtNEjNmFejvBIdBg4j+avg9MXtk7moTwpyi7mXFjQUHnjKzvsIZ3hcIjC
         F6FZXQ8I2/oIdVH97uI93qc0ZqKXG+e+mXlbY=
Date: Fri, 11 Jun 2010 23:04:06 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf_disable()
Message-ID: <20100611210405.GC5234@nowhere>
References: <1276273784.2077.2055.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276273784.2077.2055.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 06:29:44PM +0200, Peter Zijlstra wrote:
> There is a fun little recursion issue with perf_adjust_period(), where
> if we fully removed perf_disable() we could end up calling pmu::stop()
> twice and such.



We can have a local_t made nesting level on the stop/start that could easily
deal with this.

