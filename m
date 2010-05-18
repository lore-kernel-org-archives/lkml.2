Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758660Ab0ERRsH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 13:48:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758557Ab0ERRsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 13:48:04 -0400
Message-ID: <4BF2D2A7.8030803@redhat.com>
Date: Tue, 18 May 2010 20:47:19 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: davem@davemloft.net, Juan Quintela <quintela@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Arnd Bergmann <arnd@arndb.de>, kvm@vger.kernel.org,
       virtualization@lists.osdl.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, alex.williamson@redhat.com,
       amit.shah@redhat.com
Subject: Re: [PATCHv2] vhost-net: utilize PUBLISH_USED_IDX feature
References: <20100518022105.GA23129@redhat.com>
In-Reply-To: <20100518022105.GA23129@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2010 05:21 AM, Michael S. Tsirkin wrote:
> With PUBLISH_USED_IDX, guest tells us which used entries
> it has consumed. This can be used to reduce the number
> of interrupts: after we write a used entry, if the guest has not yet
> consumed the previous entry, or if the guest has already consumed the
> new entry, we do not need to interrupt.
> This imporves bandwidth by 30% under some workflows.
>    

Seems to be missing the cacheline alignment.

Rusty's clarification did not satisfy me, I think it's needed.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

