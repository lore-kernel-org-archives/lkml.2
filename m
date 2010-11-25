Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300Ab0KYQtt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 11:49:49 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48188 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab0KYQts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 11:49:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:x-url:user-agent;
        b=BMNYZMVo+0x+IsHh/Xb0CtZ955tvs2N1uWeY1+AbTRie1X4laNCAJdm+IFihTK70RE
         adpr6v0wTbVWKdcTPDGfKUk1BGX0dn5yA9T/OK1Vz47G8q+qwXj3dl7trr4XUHuvFdoa
         yZfxseE12H6p07zUdX3bCr+fBHLKZHFkfAdhE=
Date: Thu, 25 Nov 2010 14:49:40 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>, Julia Lawall <julia@diku.dk>,
        Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org,
        Matt Fleming <matt@console-pimps.org>
Subject: Re: [RFC PATCHv3] perf tools: add event grouping capability to
	"perf stat"
Message-ID: <20101125164939.GG28916@ghostprotocols.net>
References: <1290650053-3486-1-git-send-email-cjashfor@linux.vnet.ibm.com> <1290666760.2072.539.camel@laptop> <AANLkTinTNAwMCe_zu1snG1U5hSRafdBHQdzAr4e9nuWO@mail.gmail.com> <1290693720.2145.34.camel@laptop> <AANLkTinyL2eEfWoLoZqU-CFwC6Z3hGd0=9HgBhC_+Uef@mail.gmail.com> <1290694348.2145.37.camel@laptop> <AANLkTin0jv_ka9Bw0mZCeuxTWZfdLOseYdza_3e9vMi+@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTin0jv_ka9Bw0mZCeuxTWZfdLOseYdza_3e9vMi+@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Nov 25, 2010 at 03:18:58PM +0100, Stephane Eranian escreveu:
> On Thu, Nov 25, 2010 at 3:12 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > perf-record already does that:
> >
> >        if (nr_counters > 1)
> >                attr->sample_type |= PERF_SAMPLE_ID;
> >
> Ok, that's good.
> The other thing I saw, is that perf report assumes that sample_type is the
> same for all events, otherwise it dies.

Right, we need to have object attributes, and then pass them to
perf_session__new, so that it creates the counters, etc, instead of
having top, record, etc doing it in ad hoc ways.

I'll try to attack this soon, after tinishing the sample_type_id_all,
that in the kernel is per attribute, but in the tooling side suffers
from the one sample_type per session, not per attribute problem too.

- Arnaldo
