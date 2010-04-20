Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291Ab0DTPRc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 11:17:32 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:36881 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab0DTPRS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 11:17:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=MqjjHcIyGbxmYjc25Nzv+lqW0KE/jmZG8pv1V5AvfjIdAFjAfcpf/DIjIBul6HMLsQ
         zhEYpPXrX7xclxTGO79G+0k7KIsZYMFHJ7yPlyxNdBTqxt8a479A/k7U0CPxjJc/un9M
         gTmY5K4upUv3/sjYBljLQI1RyQTq3afjfC3hA=
MIME-Version: 1.0
In-Reply-To: <20100420143545.GA19513@us.ibm.com>
References: <cover.1269610458.git.luto@mit.edu> <20100419172639.GA15800@us.ibm.com> 
	<n2ycb0375e11004191432g855540c0jab7989d75b32200d@mail.gmail.com> 
	<20100419213952.GA28494@hallyn.com> <1271767039.30027.50.camel@moss-pluto.epoch.ncsc.mil> 
	<v2qcb0375e11004200723w776f806elb1be2c3aa30f1671@mail.gmail.com> 
	<20100420143545.GA19513@us.ibm.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 20 Apr 2010 11:11:55 -0400
X-Google-Sender-Auth: 8132d2d5b8473ecc
Message-ID: <n2ncb0375e11004200811x830e2047o6da43d6d3d85058@mail.gmail.com>
Subject: Re: [PATCH 0/3] Taming execve, setuid, and LSMs
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Eric Biederman <ebiederm@xmission.com>,
       "Andrew G. Morgan" <morgan@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 10:35 AM, Serge E. Hallyn <serue@us.ibm.com> wrote:
>>
>> True,  but I think it's still asking for trouble -- other LSMs could
>> (and almost certainly will, especially the out-of-tree ones) do
>> something, and I think that any action at all that an LSM takes in the
>> bprm_set_creds hook for a nosuid (or whatever it's called) process is
>> wrong or at best misguided.
>
> I could be wrong, but I think the point is that your reasoning is
> correct, and that the same reasoning must apply if we're just
> executing a file out of an fs which has been mounted with '-o nosuid'.

I tend to agree, except that only root can set nosuid (presumably) and
making that change will change existing behavior.  Is that a problem?

--Andy
