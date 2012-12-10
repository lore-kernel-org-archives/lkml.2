Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744Ab2LJXwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 18:52:41 -0500
Received: from usindpps03.hds.com ([207.126.252.16]:41389 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab2LJXwk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 18:52:40 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Don Zickus <dzickus@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        "ccross@android.com" <ccross@android.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: RE: [RFC][PATCH] pstore: Skip spinlock when just one cpu is online
Thread-Topic: [RFC][PATCH] pstore: Skip spinlock when just one cpu is online
Thread-Index: Ac3UwvCZixvXisXmRfC/Xc8ha8nnHACXEeSAAAKIfEA=
Date: Mon, 10 Dec 2012 23:52:21 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D414A1DFC8@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A1B7B2@USINDEM103.corp.hds.com>
 <20121210164215.GZ53431@redhat.com>
In-Reply-To: <20121210164215.GZ53431@redhat.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2012-12-10_07:2012-12-10,2012-12-10,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1212100244
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Now my first reaction would be, if that is the scenario, why couldn't cpuA release the lock within one second.  Because if cpuA is stuck
> talking with firmware, then your patch to force the unlock is probably going to trip over the same problems.
> (those problems include dealing with resetting a firmware state machine)
> 
> IOW, your patch is just one of many minefields you will have to cross in order to be successful.

I agree that I need to fix the platform driver's deadlocking as well to make an overall system workable. 
(I just wanted to fix the deadlocking problems step by step.)


> 
> Without any testing to show that you have cleared all those minefields, I am leaning against your patch for now.  I would rather have a
> complete patchset that fixes all the problems in this path.

Thanks. I will try to make the complete patchset.

> 
> If you did have to go this route, why not take the 'reason' variable and pass it to some function 'in_panic_path(reason)' that tells you if
> you are panicing or not.  Then you can change the 'if in_nmi()' to 'if in_nmi() || in_panic'.
> 
> The panic path already disables irqs for you, not sure you need to do it again.  Unless you have some other path you are trying to
> protect in mind.

Thank you for the suggestion.
I will update my patch in accordance with your comment if anyone else disagree that.

> 
> Cheers,
> Don
