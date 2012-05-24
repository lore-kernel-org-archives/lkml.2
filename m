Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933370Ab2EXPgl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 11:36:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51708 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761Ab2EXPgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 11:36:40 -0400
Message-ID: <4FBE5583.8070405@gmail.com>
Date: Thu, 24 May 2012 09:36:35 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH v2 4/5] perf record: add meta-data support for pipe-mode
References: <1337081295-10303-1-git-send-email-eranian@google.com> <1337081295-10303-5-git-send-email-eranian@google.com> <4FB32032.3000509@gmail.com> <CABPqkBQyZfSczhAROdH8p0_asy=c2AJho4Kv9wRYabaLNKkURA@mail.gmail.com> <4FB67DE5.8050000@gmail.com> <20120518171911.GH2636@infradead.org> <1337708035.9698.44.camel@twins> <CABPqkBTQ=K-=qkgzC0TZPi1xyHtqT6QQroRg-7o0k8rFmjH_Bw@mail.gmail.com>
In-Reply-To: <CABPqkBTQ=K-=qkgzC0TZPi1xyHtqT6QQroRg-7o0k8rFmjH_Bw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/22/12 11:51 AM, Stephane Eranian wrote:
> The problem is that the headers as they are written to the file need
> seeking in the file to update the offset table. That is NOT possible when
> you operate in pipe mode. As such you need to inject the header infos
> very much like kernel PERF_RECORD_*. That is also why you have
> perf inject -b. Buildids are added at the end of the run in file mode,
> and that's another seek to the offset table if I recall correctly.

Perhaps I am being too simple minded here, but why not dump the features 
to the pipe as a series of structs when the perf session is created?

struct pipe_data {
	u32 length;
	u32 type;
	char data[0];		
}

It would require the features to be written to a buffer first to get the 
length, but that's manageable without too much code change. Endianness 
would need to be handled -- maybe a u8 flags at the beginning.

David
