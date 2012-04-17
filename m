Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab2DQE5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 00:57:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148Ab2DQE5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 00:57:30 -0400
Date: Tue, 17 Apr 2012 07:57:37 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: netdev@vger.kernel.org, xma@us.ibm.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: [PATCH 6/6] vhost_net: don't poll on -EFAULT
Message-ID: <20120417045736.GA31278@redhat.com>
References: <20120416060749.14140.19433.stgit@intel-e5620-16-2.englab.nay.redhat.com>
 <20120416060833.14140.28139.stgit@intel-e5620-16-2.englab.nay.redhat.com>
 <20120416071646.GB25396@redhat.com>
 <4F8BD81A.7010507@redhat.com>
 <20120416133859.GB13190@redhat.com>
 <4F8CE305.9090100@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F8CE305.9090100@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 11:27:01AM +0800, Jason Wang wrote:
> On 04/16/2012 09:39 PM, Michael S. Tsirkin wrote:
> >On Mon, Apr 16, 2012 at 04:28:10PM +0800, Jason Wang wrote:
> >>>  On 04/16/2012 03:16 PM, Michael S. Tsirkin wrote:
> >>>>  >On Mon, Apr 16, 2012 at 02:08:33PM +0800, Jason Wang wrote:
> >>>>>  >>Currently, we restart tx polling unconditionally when sendmsg()
> >>>>>  >>fails. This would cause unnecessary wakeups of vhost wokers as it's
> >>>>>  >>only needed when the socket send buffer were exceeded.
> >>>>  >Why is this a problem?
> >>>  >  This issue is when guest driver is able to hit the
> >>-EFAULT, vhost
> >>>  discard the the descriptor and restart the polling. This would wake
> >>>  vhost thread and repeat the loop again which waste cpu.
> >Does same thing happen if we get an error from copy from user?
> >
> 
> Right, so do you think it makes sense that we only restart polling
> on -EAGAIN or -ENOBUFS?

Sounds OK. BTW how do you test this?

-- 
MST
