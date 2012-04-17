Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab2DQD1L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 23:27:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26965 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570Ab2DQD1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 23:27:10 -0400
Message-ID: <4F8CE305.9090100@redhat.com>
Date: Tue, 17 Apr 2012 11:27:01 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: netdev@vger.kernel.org, xma@us.ibm.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: [PATCH 6/6] vhost_net: don't poll on -EFAULT
References: <20120416060749.14140.19433.stgit@intel-e5620-16-2.englab.nay.redhat.com> <20120416060833.14140.28139.stgit@intel-e5620-16-2.englab.nay.redhat.com> <20120416071646.GB25396@redhat.com> <4F8BD81A.7010507@redhat.com> <20120416133859.GB13190@redhat.com>
In-Reply-To: <20120416133859.GB13190@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2012 09:39 PM, Michael S. Tsirkin wrote:
> On Mon, Apr 16, 2012 at 04:28:10PM +0800, Jason Wang wrote:
>> >  On 04/16/2012 03:16 PM, Michael S. Tsirkin wrote:
>>> >  >On Mon, Apr 16, 2012 at 02:08:33PM +0800, Jason Wang wrote:
>>>> >  >>Currently, we restart tx polling unconditionally when sendmsg()
>>>> >  >>fails. This would cause unnecessary wakeups of vhost wokers as it's
>>>> >  >>only needed when the socket send buffer were exceeded.
>>> >  >Why is this a problem?
>> >  
>> >  This issue is when guest driver is able to hit the -EFAULT, vhost
>> >  discard the the descriptor and restart the polling. This would wake
>> >  vhost thread and repeat the loop again which waste cpu.
> Does same thing happen if we get an error from copy from user?
>

Right, so do you think it makes sense that we only restart polling on 
-EAGAIN or -ENOBUFS?
