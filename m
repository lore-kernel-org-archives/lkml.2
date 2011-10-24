Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab1JXW36 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 18:29:58 -0400
Received: from usindpps04.hds.com ([207.126.252.17]:52927 "EHLO
	usindpps04.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab1JXW34 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 18:29:56 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
CC: =?iso-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        "holzheu@linux.vnet.ibm.com" <holzheu@linux.vnet.ibm.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 24 Oct 2011 18:24:14 -0400
Subject: RE: kdump: crash_kexec()-smp_send_stop() race in panic
Thread-Topic: kdump: crash_kexec()-smp_send_stop() race in panic
Thread-Index: AcyScyfN+nUopmkqRAag965vXy24XQAKDuUQ
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C57612A37@USINDEVS01.corp.hds.com>
References: <1319468137.3615.16.camel@br98xy6r>
 <m1ipneifqv.fsf@fess.ebiederm.org>
 <CAM_iQpVktWsgOFCWoT47dQ1YdSTnnbTZAAKNYEEX=5wWzhHMzg@mail.gmail.com>
 <m1aa8qfhdk.fsf@fess.ebiederm.org> <20111024173336.GB8044@redhat.com>
In-Reply-To: <20111024173336.GB8044@redhat.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=2 phishscore=0 bulkscore=2 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1012030000
 definitions=main-1110240261
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>> >>> 1st CPU:
>> >>> panic()->crash_kexec()->mutex_trylock(&kexec_mutex)-> do kdump
>> >>>
>> >>> 2nd CPU:
>> >>> panic()->crash_kexec()->kexec_mutex already held by 1st CPU
>> >>>        ->smp_send_stop()-> stop CPU 1 (stop kdump)
>> >>>
>> >>> How should we fix this problem? One possibility could be to do
>> >>> smp_send_stop() before we call crash_kexec().

http://lkml.org/lkml/2010/9/16/353

I developed a patch solving this issue one year ago.
(Just adding local_irq_disable in kexec path.)

I hope this helps.

Seiji

