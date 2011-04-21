Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab1DUArp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 20:47:45 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:45981 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754371Ab1DUArn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 20:47:43 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: S9ZXW7IVM1laFYZu4b5Rbjhu9OX5ozA2AZn1YXjEihnvsUa
 yS30fKEVE3z1DxIeXDGnknzX81q_QwVe9cz4oFpe6mJC.BCgQkTfokFCofUR
 UlIxsDIHb4HTOiInrcu_tN6yukTigVdh_m0epRkcOKeOhgzbAmR4hZ.JEg7Z
 bIIlOjs6MRC1hd23W6F9_kPysMkFPCvA.YcqwuGmCP9NvSF5yIqwyaJjMsy4
 hXpnVjcd73ZCRqOqt_Hv3f4goshsAox4JASqIApVnh1x3aCVAFz3UE2SR6yR
 2HICeOZxS7BVelUcQgg2l3w_Tc0rod31ubSbRJfIm2NrNy6cGnCwHQz9awby
 B1Iw.vLKRQQp8uY_oaoBoSaC.pPZAn7bkwQ--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4DAF7EAC.8010504@schaufler-ca.com>
Date: Wed, 20 Apr 2011 17:47:40 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Andi Kleen <ak@linux.intel.com>, jmorris@namei.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] SMACK: Add missing rcu_read_lock/unlock for process capability
 walk.
References: <1303336844-31074-1-git-send-email-andi@firstfloor.org> <4DAF637D.90606@schaufler-ca.com> <20110420231859.GB32402@tassilo.jf.intel.com> <4DAF6FA5.7080801@schaufler-ca.com> <20110421000818.GT16484@one.firstfloor.org>
In-Reply-To: <20110421000818.GT16484@one.firstfloor.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/20/2011 5:08 PM, Andi Kleen wrote:
>> The global list, yes. The task specific list, no. Modifying the local
>> list is like any other modification of the cred structure and requires
>> the cred be copied.
> But you still need to free it eventually right? And that freeing will
> need RCU on the reader.

Entries are never freed from the global list. Someone is working
on a patch to do that, but is running into - wait for it - locking
issues.

Entries on the local lists are only freed when the task exits.
