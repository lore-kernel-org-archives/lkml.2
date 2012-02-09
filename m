Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758123Ab2BIRNw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 12:13:52 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:46271
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752825Ab2BIRNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 12:13:51 -0500
X-SpamScore: -19
X-BigFish: VPS-19(zz1432N98dKzz1202hzz15d4Rz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LZ4YIM-02-5SJ-02
X-M-MSG: 
Date: Thu, 9 Feb 2012 18:13:34 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH 1/2] perf-tool: Don't process samples with no valid
 machine object
Message-ID: <20120209171334.GR22598@amd.com>
References: <1328803659-30449-1-git-send-email-joerg.roedel@amd.com>
 <1328803659-30449-2-git-send-email-joerg.roedel@amd.com>
 <20120209163441.GD2526@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120209163441.GD2526@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 09, 2012 at 02:34:41PM -0200, Arnaldo Carvalho de Melo wrote:
> Em Thu, Feb 09, 2012 at 05:07:38PM +0100, Joerg Roedel escreveu:
> > -		if (event->header.type == PERF_RECORD_SAMPLE) {
> > +		if (event->header.type == PERF_RECORD_SAMPLE && machine != NULL) {
> 
> Shouldn't we warn the user, even if just once, on the status (last line
> on the screen) line?

Probably yes, what would be a good message? I guess something like

	"no machine object for sample"

is not helpful to the user. Maybe something like

	"Unresolvable sample(s) recorded"?

Or something completly different?


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

