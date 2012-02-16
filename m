Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431Ab2BPBFL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 20:05:11 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:49167 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab2BPBFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 20:05:09 -0500
Message-ID: <4F3C5603.1040108@ce.jp.nec.com>
Date: Thu, 16 Feb 2012 10:04:03 +0900
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Bart Van Assche <bvanassche@acm.org>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>, jbottomley@parallels.com,
        linux-scsi@vger.kernel.org, Huajun Li <huajun.li.lee@gmail.com>,
        Axel Theilmann <theilmann@pre-sense.de>, linux-kernel@vger.kernel.org
Subject: Re: Yet another hot unplug NULL pointer dereference (was Re: status
 of oops in sd_revalidate_disk?)
References: <4EE8E419.8010000@pre-sense.de> <CAO+b5-pCW-F1nD365TnEiAfoN7zKB4zXkk3uO6p5QyUPY2icsA@mail.gmail.com> <20120214143800.69703df9@stein> <2173642.Y3HxI15Hxl@asus> <4F3B17C7.9040107@ce.jp.nec.com> <CAO+b5-rNF1R5NcSdVSsKLML4wyZBBGv-zUdq+B1y0kfHxLpupA@mail.gmail.com>
In-Reply-To: <CAO+b5-rNF1R5NcSdVSsKLML4wyZBBGv-zUdq+B1y0kfHxLpupA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 02/15/12 20:29, Bart Van Assche wrote:
> On Wed, Feb 15, 2012 at 3:26 AM, Jun'ichi Nomura <j-nomura@ce.jp.nec.com> wrote:
>> I think this patch is good, too.
>> Since QUEUE_FLAG_DEAD is also racy, it is not much different
>> from queuedata check, IMO.
> 
> Are you sure ? As far as I know the block layer takes care of
> synchronizing queue flag modifications against request_fn invocations.

QUEUE_FLAG_DEAD is set outside of queue_lock. So it's racy.
However, it's single directional change and the race is benign
if the driver, who sets QUEUE_FLAG_DEAD, is ready to reject
requests.
q->queuedata is same with that regard.

-- 
Jun'ichi Nomura, NEC Corporation
