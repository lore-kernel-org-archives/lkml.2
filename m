Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab2JIQjX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 12:39:23 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:45546 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab2JIQjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 12:39:21 -0400
X-IronPort-AV: E=Sophos;i="4.80,561,1344211200"; 
   d="scan'208";a="15046111"
Message-ID: <50745336.5080101@citrix.com>
Date: Tue, 9 Oct 2012 18:39:18 +0200
From: =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: "Oliver Chick (Intern)" <oliver.chick@citrix.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: Re: [Xen-devel] [PATCH v2] Persistent grant maps for xen blk drivers
References: <1348242767-23732-1-git-send-email-oliver.chick@citrix.com> <506061E6020000780009D4AB@nat28.tlf.novell.com>
In-Reply-To: <506061E6020000780009D4AB@nat28.tlf.novell.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/09/12 13:36, Jan Beulich wrote:
>>>> On 21.09.12 at 17:52, Oliver Chick <oliver.chick@citrix.com> wrote:
>> Changes since v1:
>>
>>  * Maximum number of persistent grants per device now 64, rather than
>>    256, as this is the actual maxmimum request in a (1 page) ring.
> 
> As said previously, I don't see why this needs to have a separate
> #define at all - it's simply __RING_SIZE(). No adding this would
> also imply that - apart from perhaps documenting the new xenstore
> nodes - io/blkif.h would need changing at all (which otherwise would
> require a hypervisor side patch to be submitted too).

I've been working on this a little bit more, and __RING_SIZE returns 32
for all ring types (blkif, blkif_x86_32 and blkif_x86_64), any specific
reason to choose __RING_SIZE()*2?

