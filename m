Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab1IPPmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 11:42:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:59056 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab1IPPmf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 11:42:35 -0400
Subject: Re: [PATCH] perf: make perf.data more self-descriptive (v4)
From: Peter Zijlstra <peterz@infradead.org>
To: David Ahern <dsahern@gmail.com>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        acme@redhat.com, mingo@elte.hu
Date: Fri, 16 Sep 2011 17:42:21 +0200
In-Reply-To: <4E736C5A.1040502@gmail.com>
References: <20110907191045.GA13475@quad> <4E6E0D0B.3080306@gmail.com>
	  <CABPqkBSfQo5E=MJ913E--dc8Fi7VLcFSGNbBf60tOnTLMuVN_w@mail.gmail.com>
	  <4E6E181E.9080506@gmail.com>
	  <CABPqkBQWd=DyRRDhaxwDGrpCs=XqyTUv72+dn7GKsT=kjPqiJg@mail.gmail.com>
	  <1315838611.26517.51.camel@twins>
	  <CABPqkBShe6OG1ukQ=7vn_Mr=Aa_c8jcbo1mYuF+41Euy5_R7Dw@mail.gmail.com>
	  <4E73622D.5010506@gmail.com> <1316186353.10174.29.camel@twins>
	 <4E736C5A.1040502@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316187741.10174.30.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-16 at 09:33 -0600, David Ahern wrote:
> 
> On 09/16/2011 09:19 AM, Peter Zijlstra wrote:
> > On Fri, 2011-09-16 at 08:50 -0600, David Ahern wrote:
> >>
> >> ppc data file: header->magic 454c494646524550
> >> x86 data file: header->magic 454c494646524550
> >>
> > Ok then we need to fix that magic thing..
> 
> Right, but it breaks backwards/forwards compatibility. e.g.,
> 
> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> index 73fa59e..603a8bb9 100644
> --- a/tools/perf/util/header.c
> +++ b/tools/perf/util/header.c
> @@ -65,9 +65,7 @@ char *perf_header__find_event(u64 id)
>     return NULL;
>  }
> 
> -static const char *__perf_magic = "PERFFILE";
> -
> -#define PERF_MAGIC (*(u64 *)__perf_magic)
> +#define PERF_MAGIC 0x5045524646494c45ULL  // "PERFFILE"
> 
>  struct perf_file_attr {
>     struct perf_event_attr  attr;
> 
> That puts the magic in the file based on endianness of the recording
> system. e.g., on x86:
> 
> $ od -c perf-magic.data | head -1
> 0000000   E   L   I   F   F   R   E   P   h  \0  \0  \0  \0  \0  \0  \0
> 
> Which means older perf binaries can't analyze new files (created with
> new magic order) and newer perf binaries can't analyze older perf files
> -- the new command will incorrectly want to do endian swapping on the
> old file.

crap.. sounds like a nice moment to ditch the current format and go for
the multi-file setup.. :-)
