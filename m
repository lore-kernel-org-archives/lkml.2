Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab2L1E3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 23:29:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61784 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753306Ab2L1E3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 23:29:37 -0500
Message-ID: <50DD2025.1050004@redhat.com>
Date: Fri, 28 Dec 2012 12:29:25 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: gaowanlong@cn.fujitsu.com
CC: mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] vhost: handle polling failure
References: <1356590360-32770-1-git-send-email-jasowang@redhat.com> <1356590360-32770-2-git-send-email-jasowang@redhat.com> <50DC1C8F.3020008@cn.fujitsu.com>
In-Reply-To: <50DC1C8F.3020008@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/27/2012 06:01 PM, Wanlong Gao wrote:
> On 12/27/2012 02:39 PM, Jason Wang wrote:
>> > Currently, polling error were ignored in vhost. This may lead some issues (e.g
>> > kenrel crash when passing a tap fd to vhost before calling TUNSETIFF). Fix this
>> > by:
> Can this kernel crash be reproduced by hand?
>
> Thanks,
> Wanlong Gao
>
>> > 
Yes, it could be simply reproduced by: open a tap fd but does not cal
TUNSETIFF, then pass it to qemu and enable vhost.
