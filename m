Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab0DTOX3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 10:23:29 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:51322 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807Ab0DTOX1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 10:23:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=XoIYHEvzBB55UDpT1YxGa4aiyl0gWUaY+DCTAGjS8PgyTTxmkuNYDIkl+3XMRa2Gzn
         DeffUl2wy7d8/++bOzNK6TDrq90+TA5C4p+3Z5sFUoMkiqkmObzSBajnlZy+AikTGDLi
         JlUs0m8DP4r+CNoXd2VeUaPPhxOkywKUPtIog=
MIME-Version: 1.0
In-Reply-To: <1271767039.30027.50.camel@moss-pluto.epoch.ncsc.mil>
References: <cover.1269610458.git.luto@mit.edu> <20100419172639.GA15800@us.ibm.com> 
	<n2ycb0375e11004191432g855540c0jab7989d75b32200d@mail.gmail.com> 
	<20100419213952.GA28494@hallyn.com> <1271767039.30027.50.camel@moss-pluto.epoch.ncsc.mil>
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 20 Apr 2010 10:23:06 -0400
X-Google-Sender-Auth: cefcf378e66447c6
Message-ID: <v2qcb0375e11004200723w776f806elb1be2c3aa30f1671@mail.gmail.com>
Subject: Re: [PATCH 0/3] Taming execve, setuid, and LSMs
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Eric Biederman <ebiederm@xmission.com>,
       "Andrew G. Morgan" <morgan@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 8:37 AM, Stephen Smalley <sds@tycho.nsa.gov> wrote:
> On Mon, 2010-04-19 at 16:39 -0500, Serge E. Hallyn wrote:
>> Quoting Andrew Lutomirski (luto@mit.edu):

>> > and LSM  transitions.  I
>> > think this is a terrible idea for two reasons:
>> >   1. LSM transitions already scare me enough, and if anyone relies on
>> > them working in concert with setuid, then the mere act of separating
>> > them might break things, even if the "privileged" (by LSM) app in
>> > question is well-written.
>>
>> hmm...
>>
>> A good point.
>
> At least in the case of SELinux, context transitions upon execve are
> already disabled in the nosuid case, and Eric's patch updated the
> SELinux test accordingly.
>

True,  but I think it's still asking for trouble -- other LSMs could
(and almost certainly will, especially the out-of-tree ones) do
something, and I think that any action at all that an LSM takes in the
bprm_set_creds hook for a nosuid (or whatever it's called) process is
wrong or at best misguided.

Can you think of anything that an LSM should do (or even should be
able to do) when a nosuid process calls exec, other than denying the
request outright?  With my patch, LSMs can still reject the open_exec
call.

--Andy
