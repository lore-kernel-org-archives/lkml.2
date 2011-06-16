Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab1FPOfZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 10:35:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754731Ab1FPOfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 10:35:22 -0400
Message-ID: <4DFA1460.2090507@redhat.com>
Date: Thu, 16 Jun 2011 11:34:08 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [media] DocBook: Use base64 for gif/png files
References: <4DFA0FF7.1030400@redhat.com> <20110616142545.GA5785@infradead.org>
In-Reply-To: <20110616142545.GA5785@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 16-06-2011 11:25, Christoph Hellwig escreveu:
> On Thu, Jun 16, 2011 at 11:15:19AM -0300, Mauro Carvalho Chehab wrote:
>> The patch utility doesn't work with non-binary files. This causes some
>> tools to break, like generating tarball targets and the scripts that
>> generate diff patches at http://www.kernel.org/pub/linux/kernel/v2.6/.
>>
>> So, let's convert all binaries to ascii using base64, and add a
>> logic at Makefile to convert them back into binaries at runtime.
> 
> Given that all the gifs are not just relatively trivial, but also things
> that looks like they originated or at least should as vector graphics
> I'd recommend to replace them by SVG files.  These also have the benefit
> of actually beeing practically patchable.

This is a good idea, but it would require to re-draw everything, as we don't
have those files vectorized (I might have one or two svg files on an older
tree, as I had to re-generate some graphics that used to be just pdf).

One of the reasons why SVG was not used in the past is that there used to have a 
target to generate pdf files, and I think that the DocBook tools available on 
that time weren't capable of working with svg. Not sure if xmlto currently
supports it, but, as we've removed the pdf generation for the media API, 
changing them to svg is ok.

Mauro.
