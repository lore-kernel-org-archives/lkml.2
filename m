Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab1BGS3d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 13:29:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754572Ab1BGS3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 13:29:31 -0500
Message-ID: <4D503A06.3010403@redhat.com>
Date: Mon, 07 Feb 2011 19:29:26 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101213 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Ted Ts'o" <tytso@mit.edu>, Matt <jackdachef@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: ext4: Fix data corruption with multi-block writepages support
References: <AANLkTi=gcf=A_6Kp6h7s2+OkxR4YUb6gqzc43asn-wfK@mail.gmail.com> <20110207174552.GC3457@thunk.org>
In-Reply-To: <20110207174552.GC3457@thunk.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2011 06:45 PM, Ted Ts'o wrote:
> On Fri, Feb 04, 2011 at 10:40:47PM +0000, Matt wrote:
>>
>> So that means that the file-corruption which existed until 2.6.37-rc6
>> and got triggered (for me) more easily via "dm crypt: scale to
>> multiple CPUs"
>> is fixed now ?
> 
> Well, a patch exists for it that will be merged into 2.6.38.
> 
>> That should give ext4 a nice speedup for >=2.6.38 :)
> 
> I'm not going to make it be the default for 2.6.38, since it's fairly
> late in the -rc features.  People who want it can explicitly enable it
> using the mount option mblk_io_submit, though.  (And let me know your
> success stories!  :-) I will be enabling it as the default in
> 2.6.39-rc1.

So it was ext4 only bug in ext4_end_bio(),
dm-crypt per-cpu code was just trigger here, right?

Milan
