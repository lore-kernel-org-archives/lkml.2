Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150Ab0FBFI5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 01:08:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128Ab0FBFIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 01:08:55 -0400
Message-ID: <4C05E752.6000403@redhat.com>
Date: Wed, 02 Jun 2010 08:08:34 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Tom Lyon <pugs@lyon-about.com>
CC: Alex Williamson <alex.williamson@redhat.com>,
       "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, chrisw@sous-sol.org, joro@8bytes.org,
       hjk@linutronix.de, gregkh@suse.de, aafabbri@cisco.com,
       scofeldm@cisco.com
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
References: <20100530121944.GH27611@redhat.com> <4C04E0E0.3070006@redhat.com> <1275452987.16980.24.camel@x201> <201006012159.41344.pugs@lyon-about.com>
In-Reply-To: <201006012159.41344.pugs@lyon-about.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2010 07:59 AM, Tom Lyon wrote:
>
> This is just what I was thinking.  But rather than a get/set, just use two fds.
>
> 	ioctl(vfio_fd1, VFIO_SET_DOMAIN, vfio_fd2);
>
> This may fail if there are really 2 different IOMMUs, so user code must be
> prepared for failure,  In addition, this is strictlyupwards compatible with
> what is there now, so maybe we can add it later.
>
>    

What happens if one of the fds is later closed?

I don't like this conceptually.  There is a 1:n relationship between the 
memory map and the devices.  Ignoring it will cause the API to have 
warts.  It's more straightforward to have an object to represent the 
memory mapping (and talk to the iommus), and have devices bind to this 
object.


-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

