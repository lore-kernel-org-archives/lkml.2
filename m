Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab1IPOu3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 10:50:29 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:49251 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752348Ab1IPOu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 10:50:27 -0400
Message-ID: <4E736229.4080300@tao.ma>
Date: Fri, 16 Sep 2011 22:50:17 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Thunderbird/3.1.13
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>,
        Maxim Patlasov <maxim.patlasov@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Corrado Zoccolo <czoccolo@gmail.com>
Subject: Re: [patch]cfq-iosched: delete deep seeky queue idle logic
References: <1316142577.29510.130.camel@sli10-conroe> <4E731CEB.2010909@tao.ma> <20110916140809.GA7026@infradead.org>
In-Reply-To: <20110916140809.GA7026@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 111.193.13.199 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2011 10:08 PM, Christoph Hellwig wrote:
> On Fri, Sep 16, 2011 at 05:54:51PM +0800, Tao Ma wrote:
>> This year's FAST has a paper named "A Scheduling Framework That Makes
>> Any Disk Schedulers Non-Work-Conserving Solely Based on Request
>> Characteristics". It has described this situation and suggests a new
>> scheduler named "stream scheduler" to resolve this. But I am not sure
>> whether CFQ can work like that or not.
> 
> As usual I suspect the best thing is to just use noop for these kinds of
> cases.  E.g. when you use xfs with the filestreams options you'll get
> patterns pretty similar to that in the initial post  - that is
> intentional as it is generally use to place them into different areas
> of a complex RAID array.  Any scheduler "smarts" will just help to break these
> I/O streams.
yeah, actually the paper does show that the performance of cfq is worse
than noop in this case. ;) See section 3.4 if you are interested.

Thanks
Tao
