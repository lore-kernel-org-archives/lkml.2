Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab0HXOzq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 10:55:46 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42308 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291Ab0HXOzm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 10:55:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eSOwbBCE2MzJQpW1/Dtwt1AQDa7IKAcCPUD2E3Cc4woleRHDCCOEnUkVyDAGvytp4Q
         J0cUobyhjb0NH+Sk5Ku8NS6y8TXdz93B9BDwJ/XcqgUZFkAZDcvxh6FiaqunT5nc03vX
         Fqohxjke3ZdE6150Iq+ADtdglqn3U3ulHc0QE=
MIME-Version: 1.0
In-Reply-To: <20100824072557.GK2804@reaktio.net>
References: <8A96806D-6CD7-44AD-8A9D-143C098C95A4@uni-paderborn.de>
	<1282256949.30453.278.camel@haakon2.linux-iscsi.org>
	<4C701E08.2020005@vlnb.net>
	<1282423398.3015.39.camel@mulgrave.site>
	<AANLkTikcReFsYMhs1RkCHoRkL1+Q9WuptHj1xbx49YsA@mail.gmail.com>
	<1282508953.3042.102.camel@mulgrave.site>
	<4C727BEB.9020100@scalableinformatics.com>
	<AANLkTim-M6dfLvJQnbieFqZCGG33E+-i+u_soCq2p9f1@mail.gmail.com>
	<AANLkTinDY8hEABHaPsCC+3wGMCn0ZLcyfDa9U9jXJ3d4@mail.gmail.com>
	<AANLkTim+fj-OL+Bixfbrxv6AgSVv_NpT-KdG6vrc6ub-@mail.gmail.com>
	<20100824072557.GK2804@reaktio.net>
Date: Tue, 24 Aug 2010 10:55:40 -0400
Message-ID: <AANLkTincXYRiMnzvOBEDn=TKq42e1zC5EVjcmeMyq7gF@mail.gmail.com>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
From: Chetan Loke <chetanloke@gmail.com>
To: =?UTF-8?B?UGFzaSBLw6Rya2vDpGluZW4=?= <pasik@iki.fi>
Cc: Bart Van Assche <bvanassche@acm.org>, Vladislav Bolkhovitin <vst@vlnb.net>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@suse.de>,
        scst-devel <scst-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 3:25 AM, Pasi Kärkkäinen <pasik@iki.fi> wrote:
> On Mon, Aug 23, 2010 at 02:03:26PM -0400, Chetan Loke wrote:
>> I actually received 3+ off-post emails asking whether I was talking
>> about initiator or target in the 100K IOPS case below and what did I
>> mean by the ACKs.
>> I was referring to the 'Initiator' side.
>> ACKs == When scsi-ML down-calls the LLD via the queue-command, process
>> the sgl's(if you like) and then trigger the scsi_done up-call path.
>>
>
> Uhm, Intel and Microsoft demonstrated over 1 million IOPS
> using software iSCSI and a single 10 Gbit Ethernet NIC (Intel 82599).

Uhm, that's MS(and it's closed tcp-chimney protocols and other
offloads?). And I think we discussed in bits and pieces about this on
scst already. Also, just because the driver is open sourced in linux
may not necessarily mean that we know all the ASIC registers that we
can bit-bang and squeeze every clock cycle out of the ASIC(just a
thought).

> How come there is such a huge difference? What are we lacking in Linux?
I'm not a iscsi-guy. So I can't comment on how the data is moved from
n/w buffers to scsi-buffers etc etc.


>
> -- Pasi
Chetan Loke

>>
>> On Mon, Aug 23, 2010 at 12:07 PM, Chetan Loke <chetanloke@gmail.com> wrote:
>> > On Mon, Aug 23, 2010 at 11:11 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>> >
>> >>
>> >> There is an important design difference between SCST and LIO: SCST by
>> >> defaults creates multiple threads to process the I/O operations for a
>> >> storage target, while LIO only creates a single thread per storage target.
>> >> This makes SCST perform measurably faster.
>> >>
>> >
>> > Forget that. You could have discussed this if there were code reviews
>> > or other mainline inclusion emails from James B. From what I have
>> > heard, the decision was taken around 8-9 months back.
>> > Would anyone like to either comment/validate/refute this please?  If
>> > not then I would kindly request these guys to stop taking us for a
>> > test drive. And also I'm not sure when was the last time James B.
>> > bench-marked our scsi-stack. Even if I ACK in the xmit-path then I
>> > can't push more than 100K IOPs. But other folks have re-engineered our
>> > linux-scsi stack and from what I've heard they can push > 300K+ IOPs.
>> > So I would just ignore performance discussion because I don't think
>> > folks have done even simple lame experiments in the last 1 year. Or
>> > may be I'm completely wrong and so please enlighten me so that I can
>> > re-run the tests.
>> >
>> >
>> >> Bart.
>> >>
>> > Chetan Loke
>> >
>>
>> ------------------------------------------------------------------------------
>> Sell apps to millions through the Intel(R) Atom(Tm) Developer Program
>> Be part of this innovative community and reach millions of netbook users
>> worldwide. Take advantage of special opportunities to increase revenue and
>> speed time-to-market. Join now, and jumpstart your future.
>> http://p.sf.net/sfu/intel-atom-d2d
>> _______________________________________________
>> Scst-devel mailing list
>> Scst-devel@lists.sourceforge.net
>> https://lists.sourceforge.net/lists/listinfo/scst-devel
>
