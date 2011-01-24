Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab1AXXbV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 18:31:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615Ab1AXXbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 18:31:20 -0500
Message-ID: <4D3E0BB9.5070805@redhat.com>
Date: Mon, 24 Jan 2011 18:31:05 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 14/16] KVM-GST: KVM Steal time registration
References: <1295892397-11354-1-git-send-email-glommer@redhat.com> <1295892397-11354-15-git-send-email-glommer@redhat.com>
In-Reply-To: <1295892397-11354-15-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2011 01:06 PM, Glauber Costa wrote:
> Register steal time within KVM. Everytime we sample the steal time
> information, we update a local variable that tells what was the
> last time read. We then account the difference.
>
> Signed-off-by: Glauber Costa<glommer@redhat.com>
> CC: Rik van Riel<riel@redhat.com>
> CC: Jeremy Fitzhardinge<jeremy.fitzhardinge@citrix.com>
> CC: Peter Zijlstra<peterz@infradead.org>
> CC: Avi Kivity<avi@redhat.com>

On second thought - how does this deal with cpu hotplug and
hot unplug?

Do you allocate a new one of these structs every time a cpu
is hot unplugged and then hotplugged, leaking the old one?

Will leaving the old value around confuse the steal time
calculation?
