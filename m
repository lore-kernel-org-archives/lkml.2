Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933582Ab2EXQTk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 12:19:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933336Ab2EXQTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 12:19:38 -0400
Date: Thu, 24 May 2012 13:19:29 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu
Subject: Re: [PATCH v2 4/5] perf record: add meta-data support for pipe-mode
Message-ID: <20120524161929.GB6344@infradead.org>
References: <1337081295-10303-1-git-send-email-eranian@google.com>
 <1337081295-10303-5-git-send-email-eranian@google.com>
 <4FB32032.3000509@gmail.com>
 <CABPqkBQyZfSczhAROdH8p0_asy=c2AJho4Kv9wRYabaLNKkURA@mail.gmail.com>
 <4FB67DE5.8050000@gmail.com>
 <20120518171911.GH2636@infradead.org>
 <1337708035.9698.44.camel@twins>
 <CABPqkBTQ=K-=qkgzC0TZPi1xyHtqT6QQroRg-7o0k8rFmjH_Bw@mail.gmail.com>
 <4FBE5583.8070405@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBE5583.8070405@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, May 24, 2012 at 09:36:35AM -0600, David Ahern escreveu:
> On 5/22/12 11:51 AM, Stephane Eranian wrote:
> >The problem is that the headers as they are written to the file need
> >seeking in the file to update the offset table. That is NOT possible when
> >you operate in pipe mode. As such you need to inject the header infos
> >very much like kernel PERF_RECORD_*. That is also why you have
> >perf inject -b. Buildids are added at the end of the run in file mode,
> >and that's another seek to the offset table if I recall correctly.

> Perhaps I am being too simple minded here, but why not dump the
> features to the pipe as a series of structs when the perf session is
> created?

> struct pipe_data {
> 	u32 length;
> 	u32 type;
> 	char data[0];		
> }

> It would require the features to be written to a buffer first to get
> the length, but that's manageable without too much code change.
> Endianness would need to be handled -- maybe a u8 flags at the
> beginning.

I guess this comes down to somebody prototyping it. The way its being
done is just the easiest one, and one that at least Peter dislikes a lot
;-)

- Arnaldo
