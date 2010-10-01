Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899Ab0JAFZt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 01:25:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705Ab0JAFZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 01:25:47 -0400
Date: Fri, 1 Oct 2010 01:25:41 -0400
From: Dave Jones <davej@redhat.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: dave@gnu.org, cpufreq@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        x86 maintainers <x86@kernel.org>
Subject: Re: [RESEND PATCH] cpufreq: unnecesary double free in
 pcc_cpufreq_do_osc
Message-ID: <20101001052540.GA31519@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Pekka Enberg <penberg@kernel.org>, dave@gnu.org,
	cpufreq@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	x86 maintainers <x86@kernel.org>
References: <1285875804.2180.1.camel@cowboy>
 <AANLkTikbSYutRGwQLU2srEQG6CO7pvXdFBQ0W216DoCv@mail.gmail.com>
 <20100930200617.GA4120@redhat.com>
 <4CA567DB.4000208@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CA567DB.4000208@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 01, 2010 at 07:47:23AM +0300, Pekka Enberg wrote:

 > > I think Dave's patch is correct.  There's a kfree(output.pointer) at line 359.
 > > If we fall all the way through without hitting any of the return -ENODEVs,
 > > we end up doing a 2nd kfree in the out_free:
 > 
 > There's a second call to acpi_evaluate_object() which takes "output" as 
 > its argument and allocates more memory.

yup. I merged your patch. after it's soaked in -next for a day, I'll push it to
Linus.  (Looks obviously correct, but just being extra careful given where
we are in the release cycle)

	Dave

