Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382Ab1KKO5Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 09:57:24 -0500
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:44743 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751284Ab1KKO5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 09:57:22 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: ZnkTsN8VM1nT76U.dF6gt50TrNoJ6pIaP687N15zS3Ro8kk
 qkf1xHbuDSubN5UiUL9SbkfkZUX7RmjhqAZpEIWvefzNO80wWF2HrJBXW.8G
 Yf.nZ8LTJYKAhzjNP.2URZOiMjmKNjv9HcYi_BzDMF3PIg65U186MXKnHCK7
 uvzDDnt3ChbHhPlqS66HPcLVwHkqoA3m466gGP4Dbju7Xv7AHlmisNoETl8v
 .tOxnt2tqMz4d81Vl6SxLAvdIlxAmi11Zg7J3mfedH5eFuz_a2McnGYU2TNV
 1cQQNfexvMeDgKV4t5doD.7zvEEiXm.Kp0MUUBBtJrIlFXxQvY1NDdu3Wy6O
 axox0JGMwZhWdAVUYIgnEBJPRM2nh021ZFbSh6O53Nd2M72ftlK9iv.dbvli
 zVlAs3.BAKAlfZum.kCbj
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 11 Nov 2011 08:57:19 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Yong Zhang <yong.zhang0@gmail.com>
cc: Shaohua Li <shaohua.li@intel.com>,
        Julie Sullivan <kernelmail.jms@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: INFO: possible recursive locking detected: get_partial_node()
 on 3.2-rc1
In-Reply-To: <20111111044202.GA21013@zhy>
Message-ID: <alpine.DEB.2.00.1111110853211.3557@router.home>
References: <20111109090556.GA5949@zhy> <201111102335.06046.kernelmail.jms@gmail.com> <1320980671.22361.252.camel@sli10-conroe> <20111111044202.GA21013@zhy>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like a false positive.

put_cpu_partial() can be called with a parameter to indicate if draining
of the per cpu partial list should be allowed ("drain"). Draining requires
taking the list lock. "drain" is set to 0 when called from
get_partial_node() (where we are already holding the list lock) so no
deadlock should be possible.
