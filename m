Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404Ab2CLWVL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 18:21:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55412 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942Ab2CLWVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 18:21:10 -0400
Message-ID: <4F5E76CE.4030601@zytor.com>
Date: Mon, 12 Mar 2012 15:21:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Jan Kratochvil <jan.kratochvil@redhat.com>
CC: Denys Vlasenko <dvlasenk@redhat.com>,
        Roland McGrath <roland@hack.frob.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Kushal Das <kdas@redhat.com>
Subject: Re: Extending coredump note section to contain filenames
References: <4F5A3A4D.1020008@redhat.com> <20120309172934.GA18173@host2.jankratochvil.net> <4F5DE6A4.2030303@redhat.com> <20120312165359.GA32400@host2.jankratochvil.net>
In-Reply-To: <20120312165359.GA32400@host2.jankratochvil.net>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2012 09:53 AM, Jan Kratochvil wrote:
> 
>> Why we don't save library names in coredump?
> 
> Because they are useless.  If you have a filename there how to find which
> content it should match?  Even if you verify the file is still there with the
> same content there is a race it can no longer be true when you read the core
> file 5 seconds later.
> 
> The build-id mapping server above always works and without races.
> 

It seems to me that there would be value in having *both*.

In particular, for libraries which aren't installed in standard system
directories (because they are test versions or mapped with dlopen()) it
would be good to have a hint of where to find them.  The build-id can
then tell you if you have the right version.

	-hpa

