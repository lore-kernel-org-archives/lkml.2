Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686Ab1K2TYH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 14:24:07 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:57978 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669Ab1K2TYF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 14:24:05 -0500
Subject: Re: [PATCH] sctp: integer overflow in sctp_auth_create_key()
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Xi Wang <xi.wang@gmail.com>
In-Reply-To: <4ED4F428.9030807@hp.com>
Date: Tue, 29 Nov 2011 14:24:01 -0500
Cc: linux-kernel@vger.kernel.org, Sridhar Samudrala <sri@us.ibm.com>,
        "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, security@kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <A1A6AF9D-8C35-4702-9693-7BCBEDE27219@gmail.com>
References: <426D7BA8-ECD0-44D6-A09F-2033F0C825FC@gmail.com> <4ED3AC7D.6090108@hp.com> <147F953A-CC69-41FF-ACD4-64E5E2956411@gmail.com> <4ED4F428.9030807@hp.com>
To: Vladislav Yasevich <vladislav.yasevich@hp.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for clarifying this!

I will leave the check there and incorporate your comments into a new patch.

- xi

On Nov 29, 2011, at 10:03 AM, Vladislav Yasevich wrote:
> 
> That should be ok as well.  There is an overflow guard in the api
> entry point so that should guard against overflows from user space.
> 
> On the network end I miscalculated a little.  The key is actually made up
> of user_key (1 short) + 2 * key_vector (3 shorts) for a total of 7*MAX_USHORT;
> however, that still will not overflow 32 bits.
> 
> -vlad

