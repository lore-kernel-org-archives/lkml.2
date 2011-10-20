Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab1JTDRd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 23:17:33 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:53541 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab1JTDRc convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Wed, 19 Oct 2011 23:17:32 -0400
MIME-Version: 1.0
In-Reply-To: <4E9C4855020000780005BA73@victor.provo.novell.com>
References: <1318260494-27985-1-git-send-email-konrad.wilk@oracle.com>
	<1318260494-27985-4-git-send-email-konrad.wilk@oracle.com>
	<1318263187.21903.464.camel@zakaz.uk.xensource.com>
	<20111010164250.GG28646@phenom.oracle.com>
	<1318274402.27397.13.camel@dagon.hellion.org.uk>
	<20111010195749.GA5755@phenom.oracle.com>
	<4E940E21020000780005AA29@nat28.tlf.novell.com>
	<20111011155133.GC29349@phenom.oracle.com>
	<20111011205729.GB22668@phenom.oracle.com>
	<4E9C4855020000780005BA73@victor.provo.novell.com>
Date: Thu, 20 Oct 2011 11:17:14 +0800
Message-ID: <CAKH3R4_TDxyNcsgZBOxQRS4U61h=bhY+Vap72AWa4CdQyQ7QfQ@mail.gmail.com>
Subject: Re: [Xen-devel] [PATCH 3/3] xen/blk[front|back]: Enhance discard
 support with secure erasing support.
From: Li Dongyang <lidongyang@novell.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Dong Yang Li <lidongyang@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think we also should mark the vbd has discard_secure if we are
usingthe file backend,as if we punch a hole in the image, those blocks
are freed tofilesystem and hardly to getthem back, or maybe write
zeros to the range before we punch the hole is better?
On Mon, Oct 17, 2011 at 9:23 PM, Jan Beulich <JBeulich@suse.com> wrote:
>>>> On 11.10.11 at 22:57, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
>> --- a/drivers/block/xen-blkfront.c
>> +++ b/drivers/block/xen-blkfront.c
>>...
>> @@ -705,7 +711,7 @@ static void blkif_free(struct blkfront_info *info, int suspend)
>>  static void blkif_completion(struct blk_shadow *s)
>>  {
>>       int i;
>
> This function gets called for all types of requests, and hence must filter
> discard ones now that what would be nr_segments can be non-zero,
> e.g.
>
>        if (s->req.operation == BLKIF_OP_DISCARD)
>                return;
>
> Jan
>
>> -     for (i = 0; i < s->req.nr_segments; i++)
>> +     for (i = 0; i < s->req.u1.nr_segments; i++)
>>               gnttab_end_foreign_access(s->req.u.rw.seg[i].gref, 0, 0UL);
>>  }
>>
>
>
