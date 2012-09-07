Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab2IGTEo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 15:04:44 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38729 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab2IGTEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 15:04:42 -0400
MIME-Version: 1.0
In-Reply-To: <504A4114.5010106@iki.fi>
References: <1346737072-24341-1-git-send-email-prabhakar.lad@ti.com>
 <20120904191227.GE6834@valkosipuli.retiisi.org.uk> <5046DEC1.6050704@ti.com> <504A4114.5010106@iki.fi>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Sat, 8 Sep 2012 00:34:21 +0530
Message-ID: <CA+V-a8vrpGDfzCdxE8U4Ch1z+DYcBEN_r6GFZ9C6D83sJh4DKw@mail.gmail.com>
Subject: Re: [PATCH v4] media: v4l2-ctrls: add control for dpcm predictor
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Prabhakar Lad <prabhakar.lad@ti.com>, LMML <linux-media@vger.kernel.org>,
        dlos <davinci-linux-open-source@linux.davincidsp.com>,
        linux-kernel@vger.kernel.org, Manjunath Hadli <manjunath.hadli@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-doc@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Rob Landley <rob@landley.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sakari,

On Sat, Sep 8, 2012 at 12:16 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Hi Prabhakar,
>
>
> Prabhakar Lad wrote:
>>
>> Hi Sakari,
>>
>> Thanks for the review.
>>
>> On Wednesday 05 September 2012 12:42 AM, Sakari Ailus wrote:
>>>
>>> Hi Prabhakar,
>>>
>>> Thanks for the patch. I've got a few comments below.
>>>
>>> On Tue, Sep 04, 2012 at 11:07:52AM +0530, Prabhakar Lad wrote:
>>>>
>>>> From: Lad, Prabhakar <prabhakar.lad@ti.com>
>>>>
>>>> add V4L2_CID_DPCM_PREDICTOR control of type menu, which
>>>> determines the dpcm predictor. The predictor can be either
>>>> simple or advanced.
>>>>
>>>> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
>>>> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
>>>> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
>>>> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>>>> Cc: Sakari Ailus <sakari.ailus@iki.fi>
>>>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>>> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
>>>> Cc: Hans de Goede <hdegoede@redhat.com>
>>>> Cc: Kyungmin Park <kyungmin.park@samsung.com>
>>>> Cc: Rob Landley <rob@landley.net>
>>>> ---
>>>> This patches has one checkpatch warning for line over
>>>> 80 characters altough it can be avoided I have kept it
>>>> for consistency.
>>>>
>>>> Changes for v4:
>>>> 1: Aligned the description to fit appropriately in the
>>>> para tag, pointed by Sylwester.
>>>>
>>>> Changes for v3:
>>>> 1: Added better explanation for DPCM, pointed by Hans.
>>>>
>>>> Changes for v2:
>>>> 1: Added documentaion in controls.xml pointed by Sylwester.
>>>> 2: Chnaged V4L2_DPCM_PREDICTOR_ADVANCE to V4L2_DPCM_PREDICTOR_ADVANCED
>>>>     pointed by Sakari.
>>>>
>>>>   Documentation/DocBook/media/v4l/controls.xml |   46
>>>> +++++++++++++++++++++++++-
>>>>   drivers/media/v4l2-core/v4l2-ctrls.c         |    9 +++++
>>>>   include/linux/videodev2.h                    |    5 +++
>>>>   3 files changed, 59 insertions(+), 1 deletions(-)
>>>>
>>>> diff --git a/Documentation/DocBook/media/v4l/controls.xml
>>>> b/Documentation/DocBook/media/v4l/controls.xml
>>>> index 93b9c68..ad873ea 100644
>>>> --- a/Documentation/DocBook/media/v4l/controls.xml
>>>> +++ b/Documentation/DocBook/media/v4l/controls.xml
>>>> @@ -4267,7 +4267,51 @@ interface and may change in the future.</para>
>>>>             pixels / second.
>>>>             </entry>
>>>>           </row>
>>>> -         <row><entry></entry></row>
>>>> +         <row>
>>>> +           <entry
>>>> spanname="id"><constant>V4L2_CID_DPCM_PREDICTOR</constant></entry>
>>>> +           <entry>menu</entry>
>>>> +         </row>
>>>> +         <row id="v4l2-dpcm-predictor">
>>>> +           <entry spanname="descr"> Differential pulse-code modulation
>>>> (DPCM) is a signal
>>>> +           encoder that uses the baseline of pulse-code modulation
>>>> (PCM) but adds some
>>>> +           functionalities based on the prediction of the samples of
>>>> the signal. The input
>>>> +           can be an analog signal or a digital signal.
>>>> +
>>>> +           <para>If the input is a continuous-time analog signal, it
>>>> needs to be sampled
>>>> +           first so that a discrete-time signal is the input to the
>>>> DPCM encoder.</para>
>>>> +
>>>> +           <para>Simple: take the values of two consecutive samples; if
>>>> they are analog
>>>> +           samples, quantize them; calculate the difference between the
>>>> first one and the
>>>> +           next; the output is the difference, and it can be further
>>>> entropy coded.</para>
>>>> +
>>>> +           <para>Advanced: instead of taking a difference relative to a
>>>> previous input sample,
>>>> +           take the difference relative to the output of a local model
>>>> of the decoder process;
>>>> +           in this option, the difference can be quantized, which
>>>> allows a good way to
>>>> +           incorporate a controlled loss in the encoding.</para>
>>>
>>>
>>> This is directly from Wikipedia, isn't it?
>>>
>> Yes.
>>
>>> What comes to the content, DPCM in the context of V4L2 media bus codes,
>>> as a
>>> digital interface, is always digital. So there's no need to document it.
>>> Entropy coding is also out of the question: the samples of the currently
>>> defined formats are equal in size.
>>>
>> Ok.
>
>
> Could you replace the above with this text (with appropriate indentation
> etc.) while keeping the reference to Wikipedia?
>
> ------8<------
> Differential pulse-code modulation (DPCM) compression can be used to
> compress the samples into fewer bits than they would otherwise require. This
> is done by calculating the difference between consecutive samples and
> outputting the difference which in average is much smaller than the values
> of the samples themselves since there is generally lots of correlation
> between adjacent pixels. In decompression the original samples are
> reconstructed. The process isn't lossless as the encoded sample size in bits
> is less than the original.
>
> Formats using DPCM compression include <xref linkend="pixfmt-srggb10dpcm8"
> />.
>
> This control is used to select the predictor used to encode the samples.
>
> The main difference between the simple and the advanced predictors is image
> quality, with advanced predictor supposed to produce better quality images
> as a result. Simple predictor can be used e.g. for testing purposes.
> ------8<------
>
Thanks for the definition. :)

Thanks and Regards,
--Prabhakar Lad

>
> Kind regards,
>
> --
> Sakari Ailus
> sakari.ailus@iki.fi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
